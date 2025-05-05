import font from '@ohos.font'
import { router } from '@kit.ArkUI';
import AccountTable from '../common/database/tables/AccountTable';
import AccountData from '../viewmodel/AccountData';
import { relationalStore } from '@kit.ArkData';
import CommonConstants from '../common/constants/CommonConstants';

const arr: undefined[] = Array.from({length: 50})
const arr3: string[] = Array.from({ length: 50 }, (_: string, i: number) => i + '');
const a = ['1', '2'];

@Component
struct MyComp {
  aboutToAppear(): void {
    font.registerFont({
      familyName: 'myfont',
      familySrc: '/fonts/iconfont.ttf'
    })
  }
  @Builder
  defaultSlot() {
    Text("default slot")
  }
  @BuilderParam slotContent: () => void = this.defaultSlot
  build() {
    Column(){
      Text("MyComp")
      this.slotContent()
    }
  }
}

function sleep(ms: number=  3000): Promise<void> {
  return new Promise((r) => {
    setTimeout(() => {
      r()
    }, ms)
  })
}


function asyncOperation() : Promise<string>{
  return new Promise((resolve, reject) => {
    // 模拟异步操作
    setTimeout(() => {
      if (Math.random() > 0.5) {
        resolve('操作成功');
      } else {
        reject('操作失败');
      }
    }, 1000);
  });
}
@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  @State accounts: AccountData[] = [];
  @State flag: boolean = false;
  @State message: string = 'Hello World';
  @State offsetY: number = 0;
  @State txt: string = "发的发生大发手动阀手动阀萨达__发的发生大发手动阀手动阀萨达__发的发生大发手动阀手动阀萨达__发的发生大发手动阀手动阀萨达"
  private accountTable = new AccountTable()
  aboutToAppear(): void {
    this.accountTable.getRdbStore(async () => {
      const result = await this.accountTable.query(0, true);
      this.accounts = result;
    })
  }
  @Builder
  tabBarBuilder() {
    Row() {
      Text("hello world")
      Image($r("app.media.adidas"))
        .width(16)
    }

  }
  build() {
    Column(){
      Button("save img").onClick(() => {
        router.pushUrl({
          url: 'pages/SaveImagePage'
        })
      })
      Button("delete store").onClick(async () => {
        try {
          const result = await relationalStore.deleteRdbStore(getContext(this), CommonConstants.ACCOUNT_TABLE.tableName)
          console.log("delete store success: ", result)
        } catch (e) {
          console.log("delete store fail:", (e as Error).message)
        }
      })
      Button("insert promise23").onClick(async () => {
        // {"id":2,"accountType":1,"typeText":"工作收入","amount":30}
        const newAccount: AccountData = { id: 0, accountType: 1, typeText: '工作收入', amount: 20 }
        const id = await this.accountTable.insertData(newAccount)
        console.log("accountTable operation insert callback success: id, ", id);
      })
      Button("insert promise").onClick(async () => {
        // {"id":2,"accountType":1,"typeText":"工作收入","amount":30}
        const newAccount: AccountData = { id: 0, accountType: 1, typeText: '工作收入', amount: 20 }
        const id = await this.accountTable.insertData(newAccount)
        console.log("accountTable operation insert promise success: id, ", id);
      })
      Button("query3").onClick(async () => {

        this.accounts = []
        await sleep()
        const result: AccountData[] = await this.accountTable.query(0, true);
        this.accounts = result;
        console.log("accountTable operation query success: resultData, ", JSON.stringify(result));
      })
      Button("navigate to v2").onClick(() => {
        router.pushUrl({
          url: 'pages/PageTestV2'
        })
      })
      ForEach(this.accounts, (item: AccountData) => {
        Row({space: 10}) {
          Text(`id: ${item.id}`)
          Text(`accountType: ${item.accountType}`)
          Text(`amount: ${item.amount}`)
          Button('delete').onClick(async () => {
            const result = await this.accountTable.deleteData(item)
            console.log('accountTable operation delete', result)
          })
          Button('update').onClick(async () => {
            const newVal: AccountData = {
              id: item.id,
              accountType: item.accountType,
              typeText: "工作收入",
              amount: Math.round(Math.random()*10 + 1)
            }
            const result = await this.accountTable.updateData(newVal)
            console.log('accountTable operation update', result)
          })
        }
      })
      Tabs({
        // barPosition:BarPosition.Start
        // animationDuration: 3
      }) {
        TabContent(){
          Column(){
            Text('\ue600')
              .fontFamily('myfont')
              .fontSize(60).fontColor(Color.Red)
            Text("首页的内容")
            MyComp()
            MyComp(){
              Text('outside content')
            }
          }
        }.tabBar(this.tabBarBuilder())
        TabContent(){
          Text("推荐的内容")
        }.tabBar("推荐")
        TabContent(){
          Text("我的内容")
        }.tabBar("我的")
      }.scrollable(true)
      .animationDuration(0)
      .barMode(BarMode.Scrollable)

      Button('scrollTo').onClick(() => {
        this.scroller.scrollTo({yOffset: 150, xOffset: 0})
      })
      Button('offset').onClick(() => {
        const x= this.scroller.currentOffset().xOffset
        const y= this.scroller.currentOffset().yOffset
        AlertDialog.show({
          message: `x: ${x}, y: ${y}`
        })
        // this.scroller.scrollEdge(Edge.Top)
      })
      Scroll(this.scroller) {
        Column(){
          ForEach(Array.from({ length: 50 }, (_: undefined, i: number) => i + ''), (item: string, index: number) => {
            Text(item).height(30).fontWeight(FontWeight.Bold).textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange).width('100%')
          }, (item: string) => item)
        }
      }.height(400)
      .width('100%')
      .scrollBarColor(Color.Blue)
      .scrollBarWidth(10)
      .scrollBar(BarState.Auto)
      .onScroll((x, y) => {
        console.log(`已经滑动的距离: x:${x}, y:${y}`)
        this.offsetY = this.scroller.currentOffset().yOffset
      })
      if (this.offsetY> 300) {
        Button('scrollEdge').onClick(() => {
          this.scroller.scrollEdge(Edge.Top)
        })
      }
    }
  }
}