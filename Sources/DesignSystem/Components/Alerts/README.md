# Alert & Dialog Components

Design System Alert ve Dialog component'leri. Native iOS alert görünümünde, özelleştirilebilir uyarı ve dialog component'leri.

## Components

### DSAlert

Basit bilgi alert'leri için kullanılır.

```swift
// Basit alert
.dsAlert(
    isPresented: $showAlert,
    title: "Başarılı",
    message: "İşlem tamamlandı.",
    primaryAction: .default("Tamam") { }
)

// İki butonlu alert
.dsAlert(
    isPresented: $showAlert,
    title: "Silmek istediğinize emin misiniz?",
    message: "Bu işlem geri alınamaz.",
    primaryAction: .destructive("Sil") { delete() },
    secondaryAction: .cancel()
)

// İkonlu alert
.dsAlert(
    isPresented: $showAlert,
    title: "Uyarı",
    message: "Kaydedilmemiş değişiklikler var.",
    icon: .warning,
    primaryAction: .default("Devam Et") { },
    secondaryAction: .cancel()
)
```

### DSConfirmationDialog

Action sheet tarzında, birden fazla seçenek sunan dialog.

```swift
.dsConfirmationDialog(
    isPresented: $showDialog,
    title: "Fotoğraf Seçenekleri",
    message: "Ne yapmak istiyorsunuz?",
    actions: [
        .default("Fotoğraflara Kaydet") { save() },
        .default("Kopyala") { copy() },
        .destructive("Sil") { delete() }
    ]
)
```

### DSCustomDialog

Özel içerik barındırabilen esnek dialog.

```swift
.dsCustomDialog(
    isPresented: $showDialog,
    title: "Profil Düzenle"
) {
    VStack(spacing: 16) {
        TextField("İsim", text: $name)
            .textFieldStyle(.roundedBorder)

        TextField("Email", text: $email)
            .textFieldStyle(.roundedBorder)
    }
} actions: [
    .cancel("İptal"),
    .default("Kaydet") { save() }
]
```

## DSAlertAction

Alert/Dialog buton aksiyonlarını temsil eder.

### Stiller

- `.default` - Standart aksiyon (mavi)
- `.cancel` - İptal aksiyonu (kalın yazı)
- `.destructive` - Tehlikeli aksiyon (kırmızı)

### Factory Methods

```swift
// Varsayılan cancel
DSAlertAction.cancel()

// Özel başlıklı cancel
DSAlertAction.cancel("İptal Et")

// Destructive aksiyon
DSAlertAction.destructive("Sil") { delete() }

// Default aksiyon
DSAlertAction.default("Tamam") { handleOK() }
```

## DSAlertIcon

Alert ikonları için enum.

```swift
.success    // Yeşil onay işareti
.warning    // Sarı uyarı üçgeni
.error      // Kırmızı X işareti
.info       // Mavi bilgi işareti
.system("star")  // Sistem ikonu
.custom(Image(...))  // Özel ikon
```

## Özellikler

- **Native Feel**: iOS alert'lerine benzer görünüm
- **Animasyon**: Scale + fade animasyonu
- **Backdrop**: Karartılmış arka plan
- **Backdrop Dismiss**: Arka plana tıklayarak kapatma (opsiyonel)
- **Keyboard Dismiss**: Alert açıldığında klavye otomatik kapanır
- **Dark Mode**: Tam dark mode desteği
- **Accessibility**: VoiceOver ve Dynamic Type desteği

## Accessibility

Tüm component'ler accessibility desteğine sahiptir:

- `accessibilityLabel` - Ekran okuyucu için etiket
- `accessibilityHint` - Destructive aksiyonlar için uyarı
- `accessibilityAddTraits(.isModal)` - Modal davranışı
- `accessibilityAddTraits(.isButton)` - Buton olarak tanımlama

## Dark Mode

Tüm component'ler otomatik olarak dark mode'u destekler:

- Arka plan renkleri sistem renklerini kullanır
- Metin renkleri dinamik olarak değişir
- İkon renkleri semantic color token'ları kullanır
