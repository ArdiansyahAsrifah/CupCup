# CupCup Watch App

**CupCup Watch App** adalah sebuah game sederhana untuk Apple Watch yang menguji ketangkasan dan daya ingat pengguna dengan permainan "shell game" alias menebak bola di bawah cangkir yang diacak. Game ini dibuat menggunakan SwiftUI dengan arsitektur MVVM untuk memisahkan logika dan tampilan.

<img width="613" alt="Screenshot 2025-05-23 at 22 07 20" src="https://github.com/user-attachments/assets/2c3b2e88-17eb-4a82-8e31-7049b2c38c81" />

---

## Fitur

- Game sederhana menebak posisi bola di bawah tiga cangkir yang diacak.
- Level dan skor yang meningkat seiring kemajuan permainan.
- Timer countdown untuk membatasi waktu memilih cangkir.
- Animasi pengacakan cangkir menggunakan `matchedGeometryEffect`.
- Tampilan responsif dengan feedback visual saat hasil tebakan ditampilkan.

---

## Teknologi

- SwiftUI (WatchOS)
- MVVM (Model-View-ViewModel) untuk pengelolaan state dan logika aplikasi.
- Timer menggunakan Combine untuk update waktu secara real-time.

---

## Struktur Proyek

- ContentView.swift (UI utama aplikasi, menampilkan cangkir, bola, skor, dan level.)
- GameViewModel.swift (Logika game, pengacakan cangkir, timer, penghitungan skor dan level.)

