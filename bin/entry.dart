import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser_console.dart';

Future main() async {

  useConsole();

  File file = new File("../index.html");
  RandomAccessFile handler = file.openSync(mode : FileMode.APPEND);

  Document doc = parse(handler);
  
  Element el = doc.querySelector("#entries");

  var server = await HttpServer.bind(
    InternetAddress.ANY_IP_V4,
    1309,
  );
  print("Listening on localhost:${server.port}");
  await for (HttpRequest req in server) {

    final HttpResponse resp = req.response;

    final HtmlEscape esc = new HtmlEscape();

    final String last_name = esc.convert(req.uri.queryParameters['last']);
    final String first_name = esc.convert(req.uri.queryParameters['first']);
    final String year = esc.convert(req.uri.queryParameters['year']);
    final String team = esc.convert(req.uri.queryParameters['team']);
    final String si = esc.convert(req.uri.queryParameters['si']);
    final String course = esc.convert(req.uri.queryParameters['course'].substring(0,3));

    final String r = """
            <tr>
              <td>$last_name</td>
              <td>$first_name</td>
              <td>$year</td>
              <td>$team</td>
              <td>$si</td>
              <td>$course</td>
              <td></td>
            </tr>
        """;

      el.innerHtml += r;

      handler.writeStringSync(doc.toString());

      resp
      ..write(r)
      ..close();
  }
}