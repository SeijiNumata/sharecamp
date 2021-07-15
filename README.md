# SHARECAMP
このサービスは、「グループで誰かが持ってきてくれればよい持ち物を、誰が持ってくるか決めることが手間」という問題を解決するために作られた共有メモサービスです。
ユーザーは、グループで持ち物リストを共有するができます。
Google Keep などの共有できるメモとは違って、「リストの作成、編集が簡単」「見やすい」「ログイン不要で共有できる」というメリットがあります。

## ローカルでの立ち上げ方
```
$ bundle install
$ rails db:create
$ rails db:migrate
$ rails s
```
## lint

```
$ yarn run lint
$ rubocop
```
## test

```
bundle exec rspec
```
