clean:
	flutter clean

test_drive: test_create_task test_edit_task test_delete_task

test_create_task:
	flutter drive --target=test_driver/create/create.dart;

test_edit_task:
	flutter drive --target=test_driver/edit/edit.dart --no-build;

test_delete_task:
	flutter drive --target=test_driver/delete/delete.dart --no-build;

