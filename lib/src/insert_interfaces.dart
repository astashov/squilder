library squilder.insert_interfaces;

import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/table_fields.dart';


abstract class InsertSetStep {
  InsertValuesStep values(Iterable values);
}

abstract class InsertValuesStep extends InsertOnDuplicateStep {
  InsertValuesStep values(Iterable values);
}

abstract class InsertOnDuplicateSetStep implements _SetMethods {
}

abstract class InsertOnDuplicateSetMoreStep implements InsertFinalStep, _SetMethods {
}

abstract class InsertOnDuplicateStep extends InsertFinalStep {
  InsertOnDuplicateSetStep onDuplicateKeyUpdate();
}

abstract class InsertFinalStep extends Serializable {
}

abstract class _SetMethods {
  InsertOnDuplicateSetMoreStep setObj(TableField field, object);
  InsertOnDuplicateSetMoreStep setField(TableField field, TableField anotherField);
}
