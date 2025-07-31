#! /usr/bin/env zsh

if which kubectl &> /dev/null; then
  source <(kubectl completion zsh)
  alias k=kubectl
  compdef __start_kubectl k
fi

function unsetkubectx() {
  alias k=kubectl
  unalias kubectl
  unalias istioctl
  unalias kail
  unset KUBE_NS
  unset KUBE_CTX
  unset HELM_KUBECONTEXT
  unset HELM_NAMESPACE
}

function kclusterstatus() {
  podcount=$(kubectl --context $1 get pods --all-namespaces --no-headers 2>/dev/null | wc -l)
  if [ "$podcount" -lt 1 ]; then
    podcount="❌"
  fi

  nodecount=$(kubectl --context $1 get nodes --no-headers 2>/dev/null | wc -l)
  if [ "$nodecount" -lt 1 ]; then
    nodecount="❌"
  fi

  avgmemorypercent=$(kubectl --context $1 top nodes 2>/dev/null | grep -v NAME | awk '{sum+=$5} END {if(NR>0) printf "%.1f", sum/NR; else print "0"}')
  if [ "$avgmemorypercent" = "0" ]; then
    avgmemorypercent="❌"
  fi

  avgcpupercent=$(kubectl --context $1 top nodes 2>/dev/null | grep -v NAME | awk '{sum+=$3} END {if(NR>0) printf "%.1f", sum/NR; else print "0"}')
  if [ "$avgcpupercent" = "0" ]; then
    avgcpupercent="❌"
  fi

  # Add % only if not ❌
  [ "$avgmemorypercent" != "❌" ] && avgmemorypercent="${avgmemorypercent}%"
  [ "$avgcpupercent" != "❌" ] && avgcpupercent="${avgcpupercent}%"

  printf "Pods: %-8s Nodes: %-8s Memory: %-8s CPU: %-8s\n" "$podcount" "$nodecount" "$avgmemorypercent" "$avgcpupercent"
}

function kallclusterstatus() {
  for ctx in $(kubectl config get-contexts -o name); do
    # Trim context name to 15 chars
    ctxname="${ctx:0:15}"
    printf "%-15s " "$ctxname"
    kclusterstatus $ctx
  done
}

function setkubectx() {
  if [[ ! -z $2 ]]; then
    export KUBE_NS=$2
  fi
  if [[ ! -z $KUBE_NS ]]; then
    alias k="kubectl --context=$1 --namespace=$KUBE_NS"
    alias kubectl="kubectl --context=$1 --namespace=$KUBE_NS"
    alias istioctl="istioctl --context=$1 --namespace=$KUBE_NS"
    alias kail="kail --context $1 --ns $KUBE_NS"
  else
    alias k="kubectl --context=$1"
    alias kubectl="kubectl --context=$1"
    alias istioctl="istioctl --context=$1"
    alias kail="kail --context $1"
  fi
  export KUBE_CTX=$1
  export HELM_KUBECONTEXT=$1
  compctl -k "($(k get namespaces -o jsonpath="{range .items[*]}{.metadata.name}{ }{end}"))" setkubens 
}
compctl -k "($(kubectl config get-contexts -o name | tr '\n' ' '))" setkubectx 

function setkubens() {
  if [[ ! -z $KUBE_CTX ]]; then
    alias k="kubectl --context=$KUBE_CTX --namespace=$1"
    alias kubectl="kubectl --context=$KUBE_CTX --namespace=$1"
    alias istioctl="istioctl --context=$KUBE_CTX --namespace=$1"
    alias kail="kail --context $KUBE_CTX --ns $1"
  else
    alias k="kubectl --namespace=$1"
    alias istioctl="istioctl --namespace=$1"
    alias kail="kail --ns $1"
  fi
  export KUBE_NS=$1
  export HELM_NAMESPACE=$1
}

function kube_prompt() {
  # Load colors for zsh
  autoload -U colors && colors
  
  if ! [ -z "$KUBE_CTX" ]; then
    echo -n "%{$fg[blue]%}[K:%{$fg[green]%}$KUBE_CTX%{$reset_color%}]-";
  fi
  if ! [ -z "$KUBE_NS" ]; then
    echo -n "%{$fg[blue]%}[KN:%{$fg[green]%}$KUBE_NS%{$reset_color%}]-";
  fi
}

# Enable prompt substitution for zsh
setopt PROMPT_SUBST
PS1='$(kube_prompt)'$PS1