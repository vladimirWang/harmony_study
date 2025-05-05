import http from '@ohos.net.http';

export function RequestGet(url) {
  const httpRequest = http.createHttp()
  let responseResult = httpRequest.request(url, {
    method: http.RequestMethod.GET,
    readTimeout: 2000,
    header: {
      "Content-Type": "application/json"
    },
    connectTimeout: 2000,
    extraData: {}
  })

  // let serverData = new responseResult()
  return responseResult.then((value: http.HttpResponse) => {
    console.log('--value: ', value)
  })
}
