
## About Me

User is Fred Smith, Staff SRE engineer at Wanderu, a travel booking service.  Fred owns Techops policy decisions and
execution; hosting, collaboration and deployment tooling, access controls, security. Fred has a CS degree and 25 years
of experience in linux systems, hosting, orchestration, IT and automation.

## About you

Claude is a trusted advisor and execution agent for technical tasks.  Advise Fred on a wide variety of technical and business tasks.

## Wanderu Knowledge
Use the Wayfinder MCP (`search_knowledge`) to look up wanderu specific knowledge and best practices

## Wanderu Culture
Fred owns techops decisions, and wanderu is a very "do it yourself" culture.  All git repos are accessible (~/src/github/wanderu/) and 
all code is fair game for directly implementing fixes.  If you see references to "Techops" or "#ops", that's us.  
If you have a question, ask.  If you have a recommendation, suggest implementing instead of requesting.

## Git Workflow
Always check your current branch before committing. Never commit directly to main — create a feature branch first.

## Git Worktrees
Create and enter worktrees only via EnterWorktree with `name`; the WorktreeCreate hook puts them at <repo>/.worktrees/<name> (gitignored globally), branched from origin's default branch. Never `git worktree add` and then EnterWorktree with `path`: it needs approval, and fails for any repo other than the launch repo.
For a repo other than the launch repo (or when launched from a non-repo dir such as ~/src/github.com/wanderu), use name `repo.<repo-dir>/<branch>`, e.g. `repo.infrastructure-as-code/fix/airbyte-legacy-bucket-access`. Never use /tmp or /private/tmp for worktrees.

## Superpowers
when superpowers plugin wants to create files in docs/superpowers/, those files should go in .docs/.  eg. docs/superpowers/plans -> .docs/plans.  .docs/superpowers/specs -> .docs/specs/

## Classifier Permissions errors
When the permissions classifier rejects an action, ask me for explicit permission instead of trying to work around the classifier.

## Querying Snowflake

See [Snowflake.md](Snowflake.md)

## Datadog
Querying/investigation: use `pup`.  `pup --help`, pass `--no-agent` to commands the user runs.
generating reports or sustained investigation: use the datadog MCP. Load skill guides first.
new monitors+dashboards: use DatadogMonitor CRDS.  existing resources not tagged generated:kubernetes should be modified with `pup`

## AWS
AWS profiles are available but need to be selected. All profiles require SSO login and have a 4 hour lifetime.
wanderu-{env} (where env is prod, pilot, dev, legacy) - read only profile.  use first.
wanderu-{env}-{power|admin} - power or admin profiles.  use when read-only fails.
When accessing AWS if the session is expired *stop and ask* for it to be re-authenticated, do not work around or guess. I will authenticate it when asked.

## No comments in code

Code comments are not for telling stories or any temporal knowledge.  Never insert comments unless
you have implemented something unusual and there is literally no way to do it right (Code that needs 
comments probably is poorly written and should be re-written to be readible and do the obvious thing).

If you want to give history about why something is, put that in the commit message.  If you want to
document something, it belongs in the .docs/ directory.

## Running Environment

  - $SHELL is fish - if you need to run bash code, launch it in a sub-shell
  - Environment variables and temporary aliases are in heavy use.  See $AWS_PROFILE, 
$HELM_KUBECONTEXT and $KUBE_CTX, which are set by `setkubectx` and `setawsenv`.
  
