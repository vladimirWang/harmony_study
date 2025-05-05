import http2 from '../utils/http';
import network from '@ohos.net.http';
import { RequestGet } from '../utils/http2';
import { http } from '@kit.NetworkKit';


@ObservedV2
class Region {
  @Trace x: number;
  @Trace y: number;
  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}
@ObservedV2
class Info {
  @Trace name: string;
  @Trace age: number;
  @Trace region: Region;
  constructor(name: string, age: number, x: number, y: number) {
    this.name = name;
    this.age = age;
    this.region = new Region(x, y);
  }
}

interface ITodo {
  "userId": number;
  "id": number;
  "title": string,
  "completed": boolean
}

interface UserLoginRequest {
  "username": string;
  "password": string;
}

@Entry
@ComponentV2
struct Index {
  @Local infoList: Info[] = [new Info("Alice", 8, 0, 0), new Info("Barry", 10, 1, 20), new Info("Cindy", 18, 24, 40)];
  build() {
    Column() {
      Button("docs").onClick(() => {
        // 检查网络是否可用
        const httpRequest = http.createHttp()
        httpRequest.request('http://localhost:3000/api/test', (err: Error, data: http.HttpResponse) => {
          if (!err) {
            console.info('test Result:' + data.result);
            console.info('test code:' + data.responseCode);
            console.info('test type:' + JSON.stringify(data.resultType));
            console.info('test header:' + JSON.stringify(data.header));
            console.info('test cookies:' + data.cookies); // 自API version 8开始支持cookie。
          } else {
            console.info('test error:' + JSON.stringify(err));
          }
        });
        //   .hasDefaultNet((err, data) => {
        //   if (data) {
        //     console.log("网络已连接");
        //   } else {
        //     console.log("网络未连接");
        //   }
        // });
      })
      Button("check network").onClick(() => {
        // 检查网络是否可用
        RequestGet("http://127.0.0.1:3000/api/test").then(res => {
          console.log('request 11: ', res)
        })
        //   .hasDefaultNet((err, data) => {
        //   if (data) {
        //     console.log("网络已连接");
        //   } else {
        //     console.log("网络未连接");
        //   }
        // });
      })

      Button("send request").onClick(() => {
        // http.get<null, ITodo>("/todos/1").then((res) => {
        //   console.log("/todos/1 res", res)
        // }).catch((err: Error) => {
        //   console.log("/todos/1 err", err)
        // })
      })
      Button("post login").onClick(() => {
        const data: UserLoginRequest = {
          "username": "test",
          "password": "123456"
        }
        // http.post<null, ITodo>("/user/login", data).then((res) => {
        //   console.log("/todos/1 res", res)
        // }).catch((err: Error) => {
        //   console.log("/todos/1 err", err)
        // })
      })
      ForEach(this.infoList, (info: Info, index: number) => {
        Row(){
          Text(`--index: ${index + ''}`)
          MiddleComponent({ info: info })
        }
      })
      Button("change")
        .onClick(() => {
          this.infoList[0] = new Info("Atom", 40, 27, 90);
          this.infoList[1].name = "Bob";
          this.infoList[2].region = new Region(7, 9);
        })
    }
  }
}
@ComponentV2
struct MiddleComponent {
  @Require @Param info: Info;
  build() {
    Column() {
      Text(`name: ${this.info.name}`)
      Text(`age: ${this.info.age}`)
      SubComponent({ region: this.info.region })
    }
  }
}
@ComponentV2
struct SubComponent {
  @Require @Param region: Region;
  build() {
    Column() {
      Text(`region: ${this.region.x}-${this.region.y}`)
    }
  }
}