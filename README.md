# HexavilleTODOExample

Serverless TODO Application using Hexaville that is written in swift4.    
This is used as demo app in [my session](https://builderscon.io/tokyo/2017/session/d0e6158e-b640-4eee-b17e-7cd77f2d0474) at [builderscon tokyo  2017](https://builderscon.io/tokyo/2017)

## Stack
* Swift4
* [Hexaville](https://github.com/noppoMan/Hexaville)
* [GitHub OAuth Application](github.com/settings/developers)
* AWS DynamoDB (Production)
* [AWS DynamoDBLocal (For Local Development)](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)

# Installation

## 1. Install Xcode9 beta4

#### Download Xcode9 beta4 from Apple Developer
* https://developer.apple.com/xcode/

#### After Downloading
```sh
sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer
```

## 2. Clone and Build
```
git clone https://github.com/noppoMan/HexavilleTODOExample.git
cd HexavilleTODOExample
swift build -c release
```

# Deploy

## 1. Install Hexaville

```sh
curl -L https://rawgit.com/noppoMan/Hexaville/master/install.sh | bash
source ~/.bashrc # ~/.zshrc
```


## 2. Export AWS Credentials

```sh
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxx
export AWS_DEFAULT_REGION=xxxxxxxxxxxxxxxxxxx
```

## 3. Create DynamoDB Tables

Run following commands before deploying

```sh
./.build/release/DynamodbSessionStoreTableManager create hexaville_todo_example_session
./.build/release/HexavilleTODOExampleDynamodbMigrator
```

## 4. Add Required Environment Variables to .env

`HEXAVILLE_BASE_URL` is unknown for the first deploying and you can get it after first deployment. So you need to deploy twice to fill it.

**.env**
```sh
GITHUB_APP_ID=xxxxxxxxxxxxxxxxxxx
GITHUB_APP_SECRET=xxxxxxxxxxxxxxxxxxx
HEXAVILLE_ENV=Production
HEXAVILLE_BASE_URL=https://xxxxxx.execute-api.ap-northeast-1.amazonaws.com/staging
```

## 5. Deploy to the AWS

```sh
curl -L https://rawgit.com/noppoMan/Hexaville/master/install.sh | bash
source ~/.bashrc # ~/.zshrc
hexaville deploy HexavilleTODOExample
```

# How to open with Xcode?

```sh
cd HexavilleTODOExample
swift package generate-xcodeproj
open *.xcodeproj
```

# Local debugging
```
cd HexavilleTODOExample
swift build
./.build/debug/HexavilleTODOExample serve
```
