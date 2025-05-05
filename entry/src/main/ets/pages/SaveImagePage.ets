import { promptAction } from '@kit.ArkUI'
import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import {fileIo} from '@kit.CoreFileKit'
import http from '@ohos.net.http';

// const request = new rcp.Request(imgUrl, 'GET');
//
// const session = rcp.createSession();
// console.log("rcp.createSession: ", session)
//
// session.fetch(request).then((rep: rcp.Response) => {
//   console.info(`fetch Response succeeded: ${rep}`);
// }).catch((err: BusinessError) => {
//   // 错误处理，通过catch块，捕获error，并对error进行处理，本示例中会将错误信息展现到打印台上。
//   console.error(`fetch Response err: Code is ${JSON.stringify(err.code)}, message is ${JSON.stringify(err)}`);
// });

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';
import fileIO from '@ohos.fileio';
const fileUri = '/data/storage/el2/base/haps/entry/cache/1746424548313.jpg'
const imgUrl = "https://img0.baidu.com/it/u=2022198414,861209178&fm=253&fmt=auto&app=138&f=JPEG?w=949&h=475"
const filePath = 'file://media/Photo/1/IMG_1746426130_000/1746424548313.jpg'


@Builder
function dialog() {
  Text("dialog")
}
async function saveImageToLocal(pixelMap: image.PixelMap) {
  const ctx = getContext()
  const imagePath = ctx.cacheDir + '/' + Date.now() + '.jpg'
  console.log("saveImageToLocal imagePath: ", imagePath)
  const file = fileIo.openSync(imagePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
  const imagePacker = image.createImagePacker()
  const packOpts: image.PackingOption = {
    format: 'image/jpeg', quality: 98
  }
  const arrayBuffer = await imagePacker.packing(pixelMap, packOpts)
  fileIo.writeSync(file.fd, arrayBuffer)
  fileIo.closeSync(file.fd)
  console.log("saveImageToLocal success")
}

@Entry
@Component
struct SaveImagePage {
  @State visible: boolean = false;
  saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_IMAGE,
    buttonType: ButtonType.Capsule
  } // 设置安全控件按钮属性。

  @State pic: Resource | image.PixelMap = $r("app.media.adidas")
  @State pic2: image.PixelMap | undefined = undefined;
  build() {
    Column() {
      Image(this.pic).width(200).onClick(async () => {
        let picker = new photoAccessHelper.PhotoViewPicker()
        let options: photoAccessHelper.PhotoSelectOptions = {
          MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
          maxSelectNumber: 1
        }
        picker.select(options).then(async (res: photoAccessHelper.PhotoSelectResult) => {
          console.log("picker.select success: ", res)
          let uri = res.photoUris[0]
          console.log("picker.select uri: ", uri)
          let file = fileIo.openSync(uri)
          // file -> imagesource -> pixelmap
          let source: image.ImageSource = image.createImageSource(file.fd)
          console.log("picker.select file: ", file)
          const decodingOptions: image.DecodingOptions = {
            editable: true,
            desiredPixelFormat: image.PixelMapFormat.RGBA_8888
          }
          const pixelMap = await source.createPixelMap(decodingOptions)
          console.log("picker.select pixelMap: ", pixelMap)
        }).catch((e: Error) => {
          console.log("picker.select fail: ", e.message)
        })
      })
      Image(this.pic2).width(100).height(100)
      Button("获取网络图片").onClick(() => {
        const request = http.createHttp()
        request.request(imgUrl, async (err, data) => {
          if (err) {
            console.log("fetch image fail: ", err.message)
            return;
          }
          if (data.responseCode === http.ResponseCode.OK) {
            const imageData: ArrayBuffer = data.result as ArrayBuffer
            const imageSource = image.createImageSource(imageData)
            const options: image.InitializationOptions = {
              alphaType: 0,
              editable: false,
              pixelFormat: 3,
              scaleMode: 1,
              size: {height: 200, width: 200}
            }
            const pixelMap = await imageSource.createPixelMap(options)
            console.log("fetch image success: ", pixelMap)
            saveImageToLocal(pixelMap)
            // await pixelMap.release()
            console.log("release success")
            this.pic2 = pixelMap
          }
        })
      })
      Image($r("sys.media.person_shield")).width(60).height(60)
      SaveButton(this.saveButtonOptions) // 创建安全控件按钮。
        .onClick(async (event, result: SaveButtonOnClickResult) => {
          if (result == SaveButtonOnClickResult.SUCCESS) {
            try {
              let context = getContext();
              let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
              // 需要确保fileUri对应的资源存在。
              // let fileUri = 'file://com.example.temptest/data/storage/el2/base/haps/entry/files/test.jpg';
              let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest = photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(context, fileUri);
              await phAccessHelper.applyChanges(assetChangeRequest);
              console.info('create asset successfully, uri: ' + assetChangeRequest.getAsset().uri);
              promptAction.showToast({
                message: '图片保存到相册'
              })
            } catch (err) {
              promptAction.showToast({
                message: '图片保存到相册失败: err' + err.message
              })
              console.error(`create asset failed with error: ${err.code}, ${err.message}`);
            }
          } else {
            promptAction.showToast({
              message: 'SaveButtonOnClickResult create asset failed'
            })
            console.error('SaveButtonOnClickResult create asset failed');
          }
        })

      Button("bindsheet").onClick(() => {
        this.visible = true;
      }).bindSheet($$this.visible, dialog, {
          height: 500,
        backgroundColor: Color.Orange
      })
    }
  }
}