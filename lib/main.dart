import 'package:flutter/material.dart';

// warp {{{

typedef F = Widget Function(
	BuildContext,
	void Function(void Function()),
	Map<String, Object>,
);

class S extends StatefulWidget {
	F f;
	Map<String, Object> state;

	S({
		super.key,
		required F f,
		required Map<String, Object> state,
	}) :
		this.f = f,
		this.state = state
	;

	State<S> createState() => _S();
}

class _S extends State<S> {
	Widget build(BuildContext context) {
		return StatefulBuilder(
			builder: (context, setState) => widget.f(
				context,
				setState,
				widget.state,
			),
		);
	}
}

void run(F app, Map<String, Object> init_state) {
	runApp(S(f: app, state: init_state));
}

// warp }}}

class Todo {
	int id;
	String task;

	Todo(this.id, this.task);

	Widget toWidget(StateSetter setState, Map<String, Object> state) =>
		TextButton(
			child: Text('${task}'),
			onPressed: () {
				var remove_todos = state['todos'] as Todos? ?? [];
				remove_todos.removeWhere((remove_todo) => remove_todo.id == id);
				setState(() => state['todos'] = remove_todos);
			},
		)
	;
}

typedef Todos = List<Todo>;

Iterable<Widget> todosWidget(
	Todos todos,
	StateSetter setState,
	Map<String, Object> state,
) =>
	todos.map<Widget>((todo) => todo.toWidget(setState, state));

Widget mainApp(
	BuildContext context,
	StateSetter setState,
	Map<String, Object> state,
) {
	return MaterialApp(
		title: 'TODO APP DEMO',

		home: Scaffold(
			appBar: AppBar(title: const Text('TODO APP DEMO')),

			body: Center(
				child: Container(
					width: 400,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						mainAxisSize: MainAxisSize.max,

						children: [
							Spacer(),

							Row(
								children: [
									Expanded(
										child: TextFormField(
											decoration: const InputDecoration(
												icon: Icon(Icons.edit_note),
												labelText: 'New Todo:',
												constraints: BoxConstraints(maxWidth: 300),
											),
											onChanged: (input) {
												setState(() {
													state['input_buffer'] = input;
												});
											},
										),
									),

									IconButton(
										icon: Icon(Icons.add),
										onPressed: () {
											var task = state['input_buffer'];
											var todos = state['todos'] as Todos? ?? [];
											if (task is String && task != "") {
												var id = todos.length;
												todos.insert(id, Todo(id, task));
											}
											setState(() => state['todos'] = todos);
										},
									),
								],
							),

							SizedBox(height: 50),

							...todosWidget(state['todos'] as Todos? ?? [], setState, state),

							Spacer(),
						],
					),
				),
			),
		),

		theme:  ThemeData(
			brightness: Brightness.dark,
			primaryColor: Colors.blueGrey,
		),
	);
}

void main() => run(mainApp, {'todos': <Todo>[]});
