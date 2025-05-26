
import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()

            VStack(spacing: 16) {
                // MARK: - Заголовок
                VStack(spacing: 4) {
                    Text(viewModel.city)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Text(viewModel.country)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer().frame(height: 8)

                // MARK: - Сегодняшняя погода
                if let today = viewModel.forecastDays.first {
                    VStack(spacing: 8) {
                        AsyncImage(url: URL(string: "https:\(today.dayInfo.condition.iconURL)")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)

                        Text(today.dayInfo.condition.description)
                            .font(.title2)
                            .foregroundColor(.white)

                        Text("\(today.dayInfo.averageTempC, specifier: "%.1f")°C")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)

                        HStack(spacing: 24) {
                            Label("\(today.dayInfo.averageHumidity, specifier: "%.0f")%", systemImage: "drop.fill")
                            Label("\(today.dayInfo.maxWindKph, specifier: "%.1f") kph", systemImage: "wind")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    }
                }

                Spacer().frame(height: 16)

                // MARK: - Next 4 days
                VStack(spacing: 4) {
                    Divider().background(Color.white)
                    Text("Next 4 days")
                        .font(.headline)
                        .foregroundColor(.white)
                    Divider().background(Color.white)
                }
                .padding(.horizontal)

                // MARK: - Список прогноза на 4 дня
                ScrollView {
                    LazyVStack(spacing: 24) { // больше расстояния между ячейками
                        ForEach(viewModel.forecastDays.dropFirst()) { day in
                            HStack(alignment: .center, spacing: 12) {
                                // Иконка погоды
                                AsyncImage(url: URL(string: "https:\(day.dayInfo.condition.iconURL)")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)

                                VStack(alignment: .leading, spacing: 6) {
                                    // 🟦 Дата и день — теперь белым
                                    Text(viewModel.shortFormattedDate(from: day.date))
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text(day.dayInfo.condition.description)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.85))

                                    HStack(spacing: 16) {
                                        Label("\(day.dayInfo.averageTempC, specifier: "%.1f")°C", systemImage: "thermometer")
                                        Label("\(day.dayInfo.averageHumidity, specifier: "%.0f")%", systemImage: "drop.fill")
                                        Label("\(day.dayInfo.maxWindKph, specifier: "%.1f") kph", systemImage: "wind")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }

                        // Spacer для растягивания
                        Spacer(minLength: 40)
                    }
                    .padding(.bottom)
                }

            }
            .padding(.top)
        }
        .task {
            await viewModel.loadWeather(for: "Moscow")
        }
        .alert("Ошибка", isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
