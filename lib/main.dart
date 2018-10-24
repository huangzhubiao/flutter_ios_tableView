import 'package:flutter/material.dart';
import 'dart:async';
import './other/lib/flutter_section_table_view.dart';
import './model/testModel.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int sectionCount = 9;
  List list;
  final controller = SectionTableController(
      sectionTableViewScrollTo: (section, row, isScrollDown) {
    print('received scroll to $section $row scrollDown:$isScrollDown');
  });
  final refreshController = RefreshController();

  Indicator refreshHeaderBuilder(BuildContext context, int mode) {
    return ClassicIndicator(
      mode: mode,
      releaseText: '释放以刷新',
      refreshingText: '刷新中...',
      completeText: '完成',
      failedText: '失败',
      idleText: '下拉以刷新',
      noDataText: '',
    );
  }

  Indicator refreshFooterBuilder(BuildContext context, int mode) {
    return ClassicIndicator(
      mode: mode,
      releaseText: '释放以加载',
      refreshingText: '加载中...',
      completeText: '加载完成',
      failedText: '加载失败',
      idleText: '上拉以加载',
      noDataText: '',
      idleIcon: const Icon(Icons.arrow_upward, color: Colors.grey),
      releaseIcon: const Icon(Icons.arrow_downward, color: Colors.grey),
    );
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      this.list = _initListData();
    }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title:new Text('tableView'),
      ),
      body: SafeArea(
        child: SectionTableView(
          refreshHeaderBuilder: refreshHeaderBuilder,
          refreshFooterBuilder: refreshFooterBuilder,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: (up) {
            print('on refresh $up');

            Future.delayed(const Duration(milliseconds: 2009)).then((val) {
              refreshController.sendBack(up, RefreshStatus.completed);
              setState(() {
                if (up) {
                  sectionCount = 5;
                } else {
                  sectionCount++;
                }
              });
            });
          },
          refreshController: refreshController,
          sectionCount: this.list.length,
          numOfRowInSection: (section) {
            TestModel model = this.list[section];
            if(model.isExpand){
              return model.list.length;
            }else{
              return 0;
            }
            
          },
          cellAtIndexPath: (section, row) {

            TestModel model = this.list[section];

            return new FlatButton(
                
                onPressed: (){
                  print("$section   $row");
                },
                child: Center(
                  child:model.list[row],
                ),
              );
          },
          headerInSection: (section) {
            TestModel model = this.list[section];
            return new FlatButton(
                color: Colors.grey,
                onPressed: (){
                 setState(() {
                       model.isExpand = !model.isExpand;                     
                 });
                },
                child: Center(
                  child: new Text('header $section'),
                ),
              );
          },
          divider: Container(
            color: Colors.black87,
            height: 0.2,
          ),
          
          controller: controller, //SectionTableController
          sectionHeaderHeight: (section) => 44.0,
          dividerHeight: () => 1.0,
          cellHeightAtIndexPath: (section, row) => 44.0,
        ),
      ),
    );
  }

  _initListData(){

    List<TestModel> list = new List();
    for(int i = 0;i < 10 ; i ++){
      List modelList = new List();
      TestModel testModel = new TestModel(isExpand: false,list:modelList);
      if(i%2 == 0){
        testModel.isExpand = true;
      }else{
        testModel.isExpand = false;
      }
      for(int j = 0 ; j < 4; j ++){
        Text text = new Text('row == $i');
        testModel.list.add(text);
      }
      
      list.add(testModel);
    }
    return list;
  }

}
