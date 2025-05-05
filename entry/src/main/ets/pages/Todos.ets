enum Status {
  ToDo,
  Doing,
  Done
}

@Observed
class Todo {
  id: number = 1;
  status: Status = Status.ToDo
}

@Entry
@Component
struct Todos {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text('1')
      Text('2')
    }
    .width('100%')
    .height("100%")
    .backgroundColor(Color.Red)
  }
}