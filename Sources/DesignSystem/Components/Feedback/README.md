# Feedback Components

Kullanıcı etkileşimleri için geri bildirim component'leri.

## Components

### DSEmptyState

Boş ve hata durumları için placeholder component.

```swift
import DesignSystem

// Basit kullanım
DSEmptyState(
    icon: "tray",
    title: "No items",
    description: "Add your first item",
    action: ("Add Item") { addItem() }
)

// Type ile kullanım
DSEmptyState(
    type: .error,
    title: "Something went wrong",
    description: "Please try again later",
    action: .primary("Retry") { retry() }
)
```

#### State Types

| Type | Icon | Açıklama |
|------|------|----------|
| `.empty` | tray | Generic boş durum |
| `.error` | exclamationmark.triangle | Hata durumu |
| `.noResults` | magnifyingglass | Arama sonuç yok |
| `.offline` | wifi.slash | İnternet yok |
| `.custom` | Özel | Özel icon ve renk |

#### Factory Methods

```swift
DSEmptyState.error(retryAction: { retry() })
DSEmptyState.noResults(clearAction: { clearFilters() })
DSEmptyState.offline(retryAction: { checkConnection() })
```

#### Size Variants

| Size | Icon Size | Container Size |
|------|-----------|----------------|
| `.small` | 40pt | 64pt |
| `.medium` | 56pt | 88pt |
| `.large` | 72pt | 112pt |

### DSToast

Basit mesaj bildirimi için toast component.

```swift
DSToast(
    message: "Saved successfully",
    type: .success
)
```

### DSSnackbar

Action button'lu toast component.

```swift
DSSnackbar(
    message: "Item deleted",
    actionTitle: "Undo",
    action: { undoDelete() }
)
```

## Accessibility

- Tüm component'ler VoiceOver destekli
- Doğru accessibility label ve hint'ler
- Action button'lar için button trait

## Dark Mode

Tüm component'ler otomatik dark mode desteği sağlar.
