# SHARECAMP
このサービスは、「グループで誰かが持ってきてくれればよい持ち物を、誰が持ってくるか決めることが手間」という問題を解決するために作られた「持ち物リスト」の共有サービスです。

例えばキャンプなどで、グループの中で1つだけクーラーボックスを誰かに持ってきて欲しい。８枚の食器が欲しいから2人くらいで分担してもいいから誰か持ってきて欲しい。
そんな時に、「誰が何をいくつ持っていくか」を共有できる持ち物リストです。

持ち物リストのURLはハッシュ化されていて、そのURLを共有するだけで他のユーザーをグループに招待できます。
グループに入った全てのユーザーが、持ち物リストを編集することができます。

他の共有できるメモサービス(Googleメモなど)と差別化したポイントとして、「リストの作成、編集が簡単」「見やすい」「ログイン不要で全ての機能が使える」というメリットがあります。

## ローカルでの立ち上げ方
```
$ ./bin/setup
$ rails s
```

## seed（テストデータ）
```
$ rails db:seed
```
ターミナルに出てきたURLに進み、ニックネームを「橋本たろう」で入力してください。

## lint

```
$ yarn run lint
$ rubocop
```
## test

```
bundle exec rspec
```
できない場合
```
rails db:drop  RAILS_ENV=test     
rails db:create  RAILS_ENV=test   
rails db:migrate  RAILS_ENV=test 
```
してから再実行してください。
