import 'dart:html' hide Point;
import 'src/examples.dart';


void main()
{
	var menu = document.querySelector('#menu');

	document.querySelector('#title').innerHtml = Examples.title(Uri.base.queryParameters);

	for (var group in Examples.groups.keys)
	{
		var heading		= new HeadingElement.h2()..innerHtml = group;
		// var list		= new UListElement()..hidden = Uri.base.queryParameters['group'] != group;
		var list		= new UListElement()..classes = Uri.base.queryParameters['group'] != group ? [ 'closed' ] : [];
		var selected	= Uri.base.queryParameters['example'];

		heading.onClick.listen((e) => list.classes.toggle('closed'));

		for (var item in Examples.groups[group].keys)
		{
			list.append(
				new LIElement()
					..classes = item == selected ? [ "selected" ] : []
					..append(
						new AnchorElement()
							..innerHtml = Examples.groups[group][item]
							..href		= "${Uri.base.origin}/?group=$group&example=$item"
							// ..classes	= item == Uri.base.queryParameters['example'] ? [ "selected" ] : []
					)
			);
		}

		menu.append(heading);
		menu.append(list);
	}


	Examples
		.create(Uri.base.queryParameters['example'])
		.run(document.querySelector('#canvas') as CanvasElement);
}
