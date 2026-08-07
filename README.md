# ERP Billing Module (Flutter)

Reusable billing module for ERP systems with modular architecture and compatibility for Flutter Android + Web.

## Features
- Sales invoice workflow
- Purchase invoice workflow
- GST calculation utility
- Inventory integration hooks
- PDF invoice generation service
- Responsive UI (mobile, tablet, web)
- **Optional day close** (`lib/day_close/`) — Z-report / shift reconciliation for POS, hospital counters, etc. HRMS and other ERPs can ignore these exports.

## Folder structure
```text
lib/
  core/
    models/
    utils/
  data/
    datasources/
    repositories/
  day_close/          # optional plug-in classes (not a separate package)
  services/
  ui/
    screens/
    state/
    widgets/
```

## Day close (optional)

Import from the same package when needed:

```dart
import 'package:erp_billing_module/erp_billing_module.dart';

final repo = DayCloseRepository(
  transactionProvider: MyProvider(),
  store: MyStore(),
);
```

Other ERPs that do not need day close simply never use `DayCloseRepository` or related classes.

## Quick usage
See `example/main.dart` for integration.
