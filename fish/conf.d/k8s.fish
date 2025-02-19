#! /usr/bin/env fish

if type -q kubectl
  kubectl completion fish | source
  alias k='kubectl'
  complete -c k -a "(kubectl __complete k)"
end

function unsetkubectx
  alias k='kubectl'
  functions -e kubectl
  functions -e istioctl
  functions -e kail
  set -e KUBE_NS
  set -e KUBE_CTX
  set -e HELM_KUBECONTEXT
  set -e HELM_NAMESPACE
end

function kclusterstatus
  set podcount (kubectl --context $argv[1] get pods --all-namespaces --no-headers 2>/dev/null | wc -l)
  if test "$podcount" -lt 1
    set podcount "❌"
  end

  set nodecount (kubectl --context $argv[1] get nodes --no-headers 2>/dev/null | wc -l)
  if test "$nodecount" -lt 1
    set nodecount "❌"
  end

  set avgmemorypercent (kubectl --context $argv[1] top nodes 2>/dev/null | grep -v NAME | awk '{sum+=$5} END {if(NR>0) printf "%.1f", sum/NR; else print "0"}')
  if test "$avgmemorypercent" = "0"
    set avgmemorypercent "❌"
  end

  set avgcpupercent (kubectl --context $argv[1] top nodes 2>/dev/null | grep -v NAME | awk '{sum+=$3} END {if(NR>0) printf "%.1f", sum/NR; else print "0"}')
  if test "$avgcpupercent" = "0"
    set avgcpupercent "❌"
  end

  # Add % only if not ❌
  if test "$avgmemorypercent" != "❌"
    set avgmemorypercent "$avgmemorypercent%"
  end
  if test "$avgcpupercent" != "❌"
    set avgcpupercent "$avgcpupercent%"
  end

  printf "Pods: %-8s Nodes: %-8s Memory: %-8s CPU: %-8s\n" "$podcount" "$nodecount" "$avgmemorypercent" "$avgcpupercent"
end

function kallclusterstatus
  for ctx in (kubectl config get-contexts -o name)
    # Trim context name to 15 chars
    set ctxname (string sub -l 15 $ctx)
    printf "%-15s " "$ctxname"
    kclusterstatus $ctx
  end
end

function setkubectx
  if test -n "$argv[2]"
    set -gx KUBE_NS $argv[2]
  end
  if test -n "$KUBE_NS"
    alias k="kubectl --context=$argv[1] --namespace=$KUBE_NS"
    alias kubectl="kubectl --context=$argv[1] --namespace=$KUBE_NS"
    alias istioctl="istioctl --context=$argv[1] --namespace=$KUBE_NS"
    alias kail="kail --context $argv[1] --ns $KUBE_NS"
  else
    alias k="kubectl --context=$argv[1]"
    alias kubectl="kubectl --context=$argv[1]"
    alias istioctl="istioctl --context=$argv[1]"
    alias kail="kail --context $argv[1]"
  end
  set -gx KUBE_CTX $argv[1]
  set -gx HELM_KUBECONTEXT $argv[1]
  complete -c setkubens -f
  complete -c setkubens -a "(kubectl --context=$argv[1] get namespaces -o name | string replace 'namespace/' '')"
end
complete -c setkubectx -f
complete -c setkubectx -a "(kubectl config get-contexts -o name)"

function setkubens
  if test -n "$KUBE_CTX"
    alias k="kubectl --context=$KUBE_CTX --namespace=$argv[1]"
    alias kubectl="kubectl --context=$KUBE_CTX --namespace=$argv[1]"
    alias istioctl="istioctl --context=$KUBE_CTX --namespace=$argv[1]"
    alias kail="kail --context $KUBE_CTX --ns $argv[1]"
  else
    alias k="kubectl --namespace=$argv[1]"
    alias istioctl="istioctl --namespace=$argv[1]"
    alias kail="kail --ns $argv[1]"
  end
  set -gx KUBE_NS $argv[1]
  set -gx HELM_NAMESPACE $argv[1]
end


function kube_prompt_info
    if test -n "$KUBE_CTX"
        if test -n "$KUBE_NS"
            echo -n "$KUBE_CTX:$KUBE_NS"
        else
            echo -n "$KUBE_CTX"
        end
    end
end

function kshell
  set -x IMAGE (or $argv[1] 'busybox:latest')
  set -x CMD (or $argv[2] '/bin/sh')
  echo "running $CMD on $IMAGE"
  k run -i -t fsmith-temp-shell-box --image=$IMAGE --restart=Never --command=true --annotations "sidecar.istio.io/inject=false" -- $CMD
  k delete pod fsmith-temp-shell-box
end
