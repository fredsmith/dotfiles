function __gwt_complete
  if not git rev-parse --git-dir >/dev/null 2>&1
    return
  end

  set -l worktree_branches (git worktree list --porcelain | sed -n 's|^branch refs/heads/||p')

  for b in $worktree_branches
    echo -e "$b\t[worktree]"
  end

  for b in (git branch --format='%(refname:short)')
    if not contains $b $worktree_branches
      echo -e "$b\tlocal branch"
    end
  end

  for b in (git branch -r --format='%(refname:short)' 2>/dev/null | grep -v HEAD | sed 's|^[^/]*/||' | sort -u)
    if not contains $b $worktree_branches
      echo -e "$b\tremote branch"
    end
  end
end

complete -c gwt -f -a "(__gwt_complete)"