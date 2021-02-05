import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  var _cache = new Map<Uri, Response>();

  @override
  Future onRequest(RequestOptions options) async {
    options.baseUrl = "https://www.google.com.hk/";
    return options;
  }

  @override
  Future onResponse(Response response) async{
    _cache[response.request.uri] = response;
  }

  @override
  Future onError(DioError e) async{
    print('onError: $e');
    if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.DEFAULT) {
      var cachedResponse = _cache[e.request.uri];
      if (cachedResponse != null) {
        return cachedResponse;
      }
    }
    return e;
  }
}


// 自己定义一个interceptor
class AppInterceptors extends Interceptor {

  @override
  Future onRequest(RequestOptions options) async {
    if (options.headers.containsKey("requiresToken")) {
      //remove the auxiliary header
      print("I am here !");
      options.headers.remove("requiresToken");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var header = prefs.get("Header");

      options.headers.addAll({"Header": "$header${DateTime.now()}"});
      options.baseUrl = "https://www.google.com.hk";
      return options;
    }
  }

  @override
  Future onError(DioError err) async {
    if (err.message.contains("ERROR_001")) {
      // this will push a new route and remove all the routes that were present
      print("error");
    }
    return err;
  }


  @override
  Future onResponse(Response response) async {
    if (response.headers.value("counter") == null) {
      //if the header is present, then compare it with the Shared Prefs key
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var verifyToken = prefs.get("counter");

      // if the value is the same as the header, continue with the request
      // if (response.headers.value("counter") == verifyToken) {
      //   return response;
      // }
      return response;
    }

    return DioError(request: response.request);
  }
}





void main() async {

  // WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setInt("counter", 1);

 

  /// Extending Interceptor Class
  // Response response;

//   // (prefs.getInt('counter')
//   dio.interceptors.add(InterceptorsWrapper(
// /// 拦截器只会将当前的Options覆盖
//       onRequest: (RequestOptions options) {
//     // print(options.connectTimeout);
//     // print(options.baseUrl);
//     // print(options.receiveTimeout);
//     // print(options.headers["api"]);
//     // print(options.headers["user-agent"]);
//     // print(options.contentType);
//     // print(options.responseType);
//     options.headers.addAll({"api": "1.0.0"});
//     options.baseUrl = "";
//     return options; //continue
//   }, onResponse: (Response response) {
//     // Do something with response data
//     // print("Response type: String");
//     // print(response.data);
//     return response; // continue
//   }, onError: (DioError e) {
//     // Do something with response error
//     print(e);
//     return e; //continue
//   }));

  
  // print("Now I am to send requests.");
  // response = await dio.get("/");
  // print(dio.options.responseType);
  // print(dio.options.headers["api"]);
  // print(dio.options.headers["user-agent"]);
  // // print("Requests finish    + ." + response.data);
  // // print("Response type: String:");
  // print(response);
  // print(dio.options.baseUrl);



  // Response<Map> responseMap = await dio.get(
  //   "/get",
  //   // Transform response data to Json Map
  //   options: Options(responseType: ResponseType.json),
  // );
  // print("Response type: json:");
  // print(responseMap.data);



  //
  // response = await dio.post(
  //   "/post",
  //   data: {
  //     "id": 1000,
  //     "info": {"name": "wendux", "age": 25}
  //   },
  //   // Send data with "application/x-www-form-urlencoded" format
  //   options: Options(
  //     contentType: Headers.formUrlEncodedContentType,
  //   ),
  // );
  // print(response.data);
  //
  // response = await dio.request(
  //   "/",
  //   options: RequestOptions(baseUrl: "https://baidu.com"),
  // );
  


  // print(response.data);



  // response = await dio.get("https://www.google.com");
  // print("data: ");
  // print(response.data);
  // print("headers: ");
  // print(response.headers);
  // print("request: ");
  // print(response.request);
  // print("status code: ");
  // print(response.statusCode);
  runApp(MyApp());
}







class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  var dio = Dio(BaseOptions(
    baseUrl: "https://www.baidu.com/",
    connectTimeout: 5000,
    receiveTimeout: 100000,
    // 5s
    headers: {
      HttpHeaders.userAgentHeader: "dio",
      "requiresToken": true,
    },
    contentType: Headers.jsonContentType,
    // Transform the response data to a String encoded with UTF8.
    // The default value is [ResponseType.JSON].
    responseType: ResponseType.plain, //string 格式
  ));
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', dio: dio),
    );
  }
}

class MyHomePage extends StatefulWidget {

  var dio;
  MyHomePage({Key key, this.title, this.dio}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  
  get dioObj {
    dio.interceptors.add(new AppInterceptors());
    return dio;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  int _counter = 0;
  String response = "None";

  void _incrementCounter(){
    setState(() {
      _counter++;
    });
  }

  Widget _getInfoMessage(String msg) {
    return Center(
      child: Text(msg),
    );
  }

  Future<Response> _getNetInfo() async {
    Response response = await widget.dioObj.get("/");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    print("Build only at the beginning");
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            FutureBuilder(
              future:   _getNetInfo(),
              builder: (buildContext, snapshot) {
                print("setState invokes me !");
                if (snapshot.hasError) {
                  return _getInfoMessage(snapshot.error.toString());
                }

                if (!snapshot.hasData) {
                  return Text("None");
                }
                Response res = snapshot.data; //_getListData()的返回值
                return Text(res.data);
              },
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
