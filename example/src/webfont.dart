@JS('WebFont')
library webfont;

// import 'dart:html';
import 'package:js/js.dart';


@JS()
external void load(Config config);

@JS()
@anonymous
class Config
{
	external factory Config({
		Google google,
		void active()
	});
}


@JS()
@anonymous
class Google
{
	external factory Google({
		List<String> families
	});
}


// // Helper function to inject the webfont library and invoke
// // the callback function when it has loaded.
// void inject(void onLoaded(Event))
// {

// 	var script = new ScriptElement()
// 		..type = 'text/javascript'
// 		..async = true
// 		..onLoad.listen(onLoaded)
// 		..src = 'https://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';

// 	document.head.append(script);
// }
