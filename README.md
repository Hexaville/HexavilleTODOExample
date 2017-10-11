# HexavilleTODOExample

Serverless TODO Web Application using Hexaville.
This is used as demo app in [my session](https://builderscon.io/tokyo/2017/session/d0e6158e-b640-4eee-b17e-7cd77f2d0474) at [builderscon tokyo  2017](https://builderscon.io/tokyo/2017)


## Subjects
* [Instructions for Local Development](#instructions-for-Local-Development)
* [Instructions for Deployment](#instructions-for-deployment)

# Before Installation

This example application requires [GitHub OAuth App](https://github.com/settings/developers).
Before installation, you had better to create it.

The callbak url should be `http://your-host.com/auth/github/callbak`

# Instructions for Local Development

## Stacks
* Xcode 9(Swift 4)
* [AWS DynamoDBLocal](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)

## 1. Installing DynamoDBLocal

There are two ways to install DynamoDBLocal

1. Setup with Docker. The image is [here](https://hub.docker.com/r/deangiberson/aws-dynamodb-local/)
2. Download and install DynamoDBLocal from [here](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)

In any case, You need to keep it start while local development.

## 2. Export Environment Variables

Export dynamodb endpoint and GitHub OAuth Application credential as Environment variables.

```
export DYNAMODB_ENDPOINT=http://localhost:8000
GITHUB_APP_ID=xxxxxxxxxxxxxxxxxxx
GITHUB_APP_SECRET=xxxxxxxxxxxxxxxxxxx
```

## 3. Build HexavilleTODOExample

```sh
$ git clone https://github.com/noppoMan/HexavilleTODOExample.git
$ cd HexavilleTODOExample
$ make install
```

`make install` do following steps.

1. `swift build`
2. DynamoDB migration for creating tables that are used in app.

## 4. Start Debug Server

```
$ ./.build/debug/hexaville-todo-example serve
```

## 5. Access From Browser

Access `http://localhost:3000/` from your browser and then, You'll see `Welcome to Hexaville!`

That's it!


## Extra. Open HexavilleTODOExample with Xcode

You can open and edit HexavilleTODOExample project with Xcode to follow following steps.

```sh
$ swift package generate-xcodeproj
$ open HexavilleTODOExample.xcodeproj
```

# Instructions for Deployment

## 1. Cloning Repo

```
$ git clone https://github.com/noppoMan/HexavilleTODOExample.git
$ cd HexavilleTODOExample
```

## 2. Edit your Hexavillefile.yml

replace `xxxxxxxxxxxxxxxxxx` for `credential`, `region` and `bucket` with your environment in Hexavillefile.yml.

If you don't give `role`(ARN) for Lambda, The IAM user that use in `credential` need to have `AdministratorAccess`.

```yaml
name: HexavilleTODOExample
service: aws
aws:
  credential:
    access_key_id: xxxxxxxxxxxxxxxxxx # change here
    secret_access_key: xxxxxxxxxxxxxxxxxx # change here
  region: ap-northeast-1  # change here if needed
  lambda:
    bucket: xxxxxxxxxxxxxxxxxx # change here
#    role: xxxxxxxxxxxxxxxxxx # change here if needed
  build:
    nocache: false
swift:
  version: "4.0"
  build:
    configuration: release
```

## 3. Add Required Environment Variables to .env

`GITHUB_APP_ID` and `GITHUB_APP_SECRET` can get from your Oauth Application page on GitHub.

**.env**
```
GITHUB_APP_ID=xxxxxxxxxxxxxxxxxxx
GITHUB_APP_SECRET=xxxxxxxxxxxxxxxxxxx
HEXAVILLE_ENV=production
```

## 4. Deploy to AWS

```sh
$ cd HexavilleTODOExample
$ make deploy
```

`make deploy` do following steps.

1. DynamoDB migration for creating tables that are used in app.
2. hexaville deploy

## 5. Access from Browser

After deploying, You can get endpoint information from standard output.
