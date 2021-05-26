CURRENTDIR=${pwd}

# step 0 : Get variables from ~/.env
GITHUB_USERNAME=$(grep GITHUB_USERNAME ~/.env | xargs)
IFS='=' read -ra GITHUB_USERNAME <<< "$GITHUB_USERNAME"
GITHUB_USERNAME=${GITHUB_USERNAME[1]}

GITHUB_ACCESS_TOKEN=$(grep GITHUB_ACCESS_TOKEN ~/.env | xargs)
IFS='=' read -ra GITHUB_ACCESS_TOKEN <<< "$GITHUB_ACCESS_TOKEN"
GITHUB_ACCESS_TOKEN=${GITHUB_ACCESS_TOKEN[1]}

DEFAULT_PATH=$(grep DEFAULT_PATH ~/.env | xargs)
IFS='=' read -ra DEFAULT_PATH <<< "$DEFAULT_PATH"
DEFAULT_PATH=${DEFAULT_PATH[1]}

# step 1 : name of the remote repo. Enter a SINGLE WORD ..or...separate with hyphens
echo "What name do you want to give your remote repo? (Enter a SINGLE WORD or separate with hyphens)"
read REPO_NAME

echo "Enter a repo description: "
read DESCRIPTION

PROJECT_PATH=$DEFAULT_PATH$REPO_NAME

if [ ! -d "$PROJECT_PATH" ]
then
    echo "Directory doesn't exist. Creating now"
    mkdir $PROJECT_PATH
    echo "Directory created"
else
    echo "Directory exists"
fi

# step 2 : Go to the project path 
cd "$PROJECT_PATH"

# step 3 : Initialize the repo locally, create README.md, add and commit
git init
echo "$REPO_NAME" >> README.md
git add README.md
git commit -m 'Initial Commit'

# step 4 : Use Github API to log in and create repo.
curl -u ${GITHUB_USERNAME}:${GITHUB_ACCESS_TOKEN} https://api.github.com/user/repos -d "{\"name\": \"${REPO_NAME}\", \"description\": \"${DESCRIPTION}\"}"

# step 5 : Add the remote github repo to local repo and push
git remote add origin https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git
git push --set-upstream origin master

echo "Done. Go to https://github.com/${GITHUB_USERNAME}/$REPO_NAME to see." 
echo " *** You're now in your project root. ***"

# step 6 : Open in Visual Studio Code
code .
