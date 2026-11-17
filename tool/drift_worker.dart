// Web-Worker für drift (geteilte SQLite-Instanz im Browser).
// Neu bauen mit: dart compile js -O4 tool/drift_worker.dart -o web/drift_worker.js
import 'package:drift/wasm.dart';

void main() => WasmDatabase.workerMainForOpen();
