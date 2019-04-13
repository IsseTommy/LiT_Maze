# ガチャアプリ
***
## １、押さえておくポイント、Swift言語特性
### コーディングでviewを追加する方法
1. まず、以下のようなcreateViewなどのviewを作るメゾットを作る
```
func createView(x: Int, y: Int, width: CGFloat, height: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> UIView {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(x: offsetX + width * CGFloat(x), y: offsetY + height * CGFloat(y))
        
        view.center = center
        
        return view
    }
```
1. addSubviewというコードを使って表示しているviewに画面を追加する。
例
```
view.addSubview(goalView)
```

---

### switch文
Switch文はある一つの変数の値によって実行するコードを変えることができるものである。  
公式
```
switch 変数{
  case 1:
    コード
  case 2:
    コード
  case 3:
    コード
  default:
    break
}
```
※defaultを書かないとエラーが出るので注意

---

### モーションセンサーなどのセンサーを使いたい場合
import UIKitの下に以下のコードを入力するとセンサーにアクセスすることができる
```
import CoreMotion
```

___

## ２、エラー

### switchの部分でエラーが発生しビルドできない
#### 原因
defaultの部分がない可能性がある。
