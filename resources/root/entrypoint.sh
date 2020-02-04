#!/bin/sh -l

ssh-keyscan github.com >> /root/.ssh/known_hosts
ssh-keyscan -t rsa "${INPUT_DOKKU_REPO_IP}" >> /root/.ssh/known_hosts
chmod 600 /root/.ssh/known_hosts

echo "${INPUT_REPO_KEY}" >> /root/.ssh/repo_key
echo "${INPUT_DEPLOY_KEY}" >> /root/.ssh/deploy_key

chmod 0600 /root/.ssh/repo_key
chmod 0600 /root/.ssh/deploy_key

eval $(ssh-agent)

ssh-add /root/.ssh/repo_key
ssh-add /root/.ssh/deploy_key

git clone git@github.com:"${INPUT_MAIN_REPO}".git /tmp/split

git chechout "${INPUT_BRANCH}"

cd /tmp/split

git subtree push --prefix web "${INPUT_DOKKU_REPO}" master
