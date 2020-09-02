# Terraform and Serverless demo

TerraformでLambdaをデプロイするデモです。

**lambda.tf**

ProvisioningをするTerraformのコード

**main.js**

デプロイするファンクションのコード（Node.js）

**script/deploy_tfc.sh**

GitHub actionsから呼ばれるスクリプト。TFC上のVariableをアップデートし、lambda.tfを流し込んでRunをトリガーします。

**.github/workflows/blank.yml**

GitHub actions(CI/CD)の設定ファイルです。この中のステップで、コードのパッケージングとデプロイ、そして上記のdeploy_tfc.shを実行します。

## TFCのWorkspace設定

WorkspaceはAPI-driven workflowで作成してください。(VCS連携は必要ありません）

`artifact`という変数を定義します。これがS3にアップロードされたアプリケーションのパッケージになります。

作成したWorkspaceのWorkspace IDと`artifact`変数のIDをdeploy_tfc.shに記入します。

WorkspaceのSecure environment variableにAWSへのアクセスキーとシークレットキーを登録します。

あとは、GitHub ActionsからRunがトリガーされます。
