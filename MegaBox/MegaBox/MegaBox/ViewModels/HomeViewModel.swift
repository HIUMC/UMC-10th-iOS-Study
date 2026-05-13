import Observation

@Observable
class HomeViewModel {
    // 선택된 차트 타입 상태 관리 (변경 시 UI 자동 업데이트)
    var selectedChartType: MovieChartType = .nowPlaying
    
    enum MovieChartType {
        case nowPlaying, upcoming
    }
    
    // 연산 프로퍼티: 탭 상태에 따라 보여줄 배열을 결정
    var currentMovies: [MovieModel] {
        selectedChartType == .nowPlaying ? movies : upcomingMovies
    }
    
    // 데이터 배열
    var movies: [MovieModel] = [
        MovieModel(title: "왕과 사는 남자", posterImage: "kingsWarden", audienceCount: 1475, englishTitle: "The King's Warden", quote: "\"닿은 숲을 보더라도 그 대감을 우리 광전골로 오게 해야지.\"", description: "계유정난이 조선을 뒤흔들고...", rating: "12세 이상 관람가", releaseInfo: "2026.02.04 · 개봉 · 117분", genre: "드라마, 사극", type: "2D", director: "장항준", cast: "유해진, 박지훈, 유지태, 전미도, 안재홍, 김민"),
        MovieModel(title: "프로젝트 헤일메리", posterImage: "project", audienceCount: 56, englishTitle: "Project Hail Mary", quote: "\"이 미션은 나 혼자만의 것이 아니다.\"", description: "태양이 서서히 죽어가고 있는 위기 속...", rating: "12세 이상 관람가", releaseInfo: "2026.03.18 · 개봉 · 142분", genre: "SF, 스릴러", type: "2D, IMAX, 4DX", director: "필 로드, 크리스토퍼 밀러", cast: "라이언 고슬링, 산드라 휠러"),
        MovieModel(title: "호퍼스", posterImage: "hoppers", audienceCount: 6, englishTitle: "Hoppers", quote: "\"완벽한 비버의 삶 속으로!\"", description: "동물들의 뇌에 인간의 의식을 전송하는...", rating: "전체 관람가", releaseInfo: "2026.03.04 · 개봉 · 104분", genre: "애니메이션, 코미디", type: "2D, 더빙, 자막", director: "대니얼 총", cast: "성우: 파이퍼 커다, 바비 모니한, 존 햄")
    ]
    
    var upcomingMovies: [MovieModel] = [
        MovieModel(title: "메소드연기", posterImage: "method", audienceCount: 0, englishTitle: "Method Acting", quote: "\"진짜 나를 연기하라!\"", description: "코미디언 출신으로 정극 연기에 도전하지만...", rating: "12세 이상 관람가", releaseInfo: "2026 · 개봉 예정", genre: "코미디, 드라마", type: "2D", director: "이기혁", cast: "이동휘, 강찬희, 윤경호")
    ]
    
    // 극장 정보 (기존 유지)
    let theaters: [TheaterModel] = [
        TheaterModel(logo: "Dolby Cinema 로고", card: "Dolby Cinema", name: "Dolby Cinema", title: "DOLBY CINEMA", description: "완벽한 영화 관람을 완성하는\n하이엔드 시네마")
    ]
}
