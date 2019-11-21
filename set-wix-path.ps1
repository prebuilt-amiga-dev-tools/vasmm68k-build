# GitHub runners have a WIX environment variable which points out the WIX install location
# See https://help.github.com/en/actions/automating-your-workflow-with-github-actions/software-installed-on-github-hosted-runners

$env:Path += ";${WIX}\bin";