import router from '@ohos.router'
import { Want } from '@kit.AbilityKit';

class Tmp {
  paramA1: string = '';
}

@Builder
function overBuilder(params: Tmp) {
  Row() {
    Text(`UseStateVarByReference: ${params.paramA1} `)
  }
}

@Component
struct Parent {
  @State label: string = 'Hello';

  build() {
    Column() {
      // 在父组件中调用overBuilder组件时，
      // 把this.label通过引用传递的方式传给overBuilder组件。
      overBuilder({ paramA1: this.label })
      Button('Click me').onClick(() => {
        // 单击Click me后，UI文本从Hello更改为ArkUI。
        this.label = 'ArkUI';
      })
    }
  }
}

interface User {
  username: string
  id: number;
  gender: number;
}

class C {
  n: number = 0
  s: string = ''
}

@Component
struct MyComp {
  onPageShow(): void {
    console.log("lifetime Component MyComp: onPageShow")
  }

  onPageHide(): void {
    console.log("lifetime Component MyComp: onPageHide")
  }

  aboutToAppear(): void {
    console.log("lifetime Component MyComp: aboutToAppear")
  }

  aboutToDisappear(): void {
    console.log("lifetime Component MyComp: aboutToDisappear")
  }

  build() {
    Column() {
      Text("MyComp")
    }
  }
}

let a1 = [{ n: 1, s: '1' } as C, { n: 2, s: '2' } as C]; // a1的类型为“C[]”
let a2: C[] = [{ n: 1, s: '1' }, { n: 2, s: '2' }]; // a2的类型为“C[]”

@Entry
@Component
struct Login {
  @State message: string = 'Hello World';
  @State list: User[] = [
    { username: 'mike', id: 1, gender: 12 },
    { username: 'john', id: 2, gender: 13 },
  ]

  onPageShow(): void {
    console.log("lifetime page login: onPageShow")
  }

  onPageHide(): void {
    console.log("lifetime page login: onPageHide")
  }

  aboutToAppear(): void {
    console.log("lifetime page login: aboutToAppear")
  }

  aboutToDisappear(): void {
    console.log("lifetime page login: aboutToDisappear")
  }

  build() {
    RelativeContainer() {
      Parent()
      MyComp()
      Button('login').onClick(() => {
        router.replaceUrl({
          url: "pages/Index",
        })
      })
      // Button("吊起另一个ability").onClick(() => {
      //   let want: Want = {
      //     deviceId: '',
      //     bundleName: 'com.example.myapplication',
      //     moduleName: "entry",
      //     abilityName: 'SecondEntryAbility'
      //   }
      //   // start
      // })
      ForEach(this.list, (user: User) => {
        Text(user.username)
      }, (user: User) => user.id + '')
      Text(this.message)
        .id('LoginHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })
    }
    .height('100%')
    .width('100%')
  }
}