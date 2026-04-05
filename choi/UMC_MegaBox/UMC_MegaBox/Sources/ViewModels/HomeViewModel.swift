import Foundation

@Observable
class HomeViewModel {
    var movies: [MovieModel] = [
        MovieModel(
            title: "왕과 사는 남자",
            posterImage: "kingsWarden",
            audienceCount: 1000,
            englishTitle: "The King's Warden",
            quote: "\"닿은 숲을 보더라도 그 대감을 우리 광전골로 오게 해야지.\"",
            description: "계유정난이 조선을 뒤흔들고, 어린 왕 단종이 왕위에서 쫓겨나 유배길에 오른다. 강원도 영월 산골 마을 광전골의 촌장 조유례와 엄흥도는 먹고살기 힘든 마을 사람들을 위해 정영포를 유배지로 만들려 고군분투한다.",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.02.04 · 개봉 · 117분",
            genre: "드라마, 사극",
            type: "2D",
            director: "장항준",
            cast: "유해진, 박지훈, 유지태, 전미도, 안재홍, 김민"
        ),
        MovieModel(
            title: "프로젝트 헤일메리",
            posterImage: "project",
            audienceCount: 120,
            englishTitle: "Project Hail Mary",
            quote: "\"이 미션은 나 혼자만의 것이 아니다.\"",
            description: "태양이 서서히 죽어가고 있는 위기 속, 기억을 잃은 채 우주선에서 깨어난 과학자 라일랜드 그레이스가 인류를 멸망에서 구하기 위해 미지의 외계 생명체와 협력하여 불가능한 미션에 도전하는 SF 생존 스릴러.",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.03.18 · 개봉 · 142분",
            genre: "SF, 스릴러",
            type: "2D, IMAX, 4DX",
            director: "필 로드, 크리스토퍼 밀러",
            cast: "라이언 고슬링, 산드라 휠러"
        ),
        MovieModel(
            title: "호퍼스",
            posterImage: "hoppers",
            audienceCount: 210,
            englishTitle: "Hoppers",
            quote: "\"완벽한 비버의 삶 속으로!\"",
            description: "동물들의 뇌에 인간의 의식을 전송하는 최첨단 기술을 통해 비버의 삶을 살게 된 인간 소녀 메이블. 동물들의 세계에 깊숙이 잠입하면서 펼쳐지는 유쾌한 픽사 애니메이션.",
            rating: "전체 관람가",
            releaseInfo: "2026.03.04 · 개봉 · 104분",
            genre: "애니메이션, 코미디",
            type: "2D, 더빙, 자막",
            director: "대니얼 총",
            cast: "성우: 파이퍼 커다, 바비 모니한, 존 햄"
        ),
        MovieModel(
            title: "휴민트",
            posterImage: "humint",
            audienceCount: 450,
            englishTitle: "HUMINT",
            quote: "\"누구도 믿을 수 없는 첩보전이 시작된다.\"",
            description: "블라디보스토크 국경에서 발생하는 범죄를 파헤치기 위해 나선 남북한 비밀 요원들이 서로 충돌하며 벌어지는 첩보 액션 영화.",
            rating: "15세 이상 관람가",
            releaseInfo: "2026.04 · 개봉 예정",
            genre: "액션, 스파이",
            type: "2D, IMAX",
            director: "류승완",
            cast: "조인성, 박정민, 박해준, 나나"
        ),
        MovieModel(
            title: "매드댄스오피스",
            posterImage: "madDance",
            audienceCount: 85,
            englishTitle: "Mad Dance Office",
            quote: "\"스텝을 밟으니 인생이 풀린다!\"",
            description: "승진을 위해 열정을 불태우는 완벽주의 직장인, 하지만 스트레스는 최고조! 우연히 동네 댄스 학원에 등록하게 되면서 춤을 통해 인생의 새로운 스텝을 밟아가는 유쾌한 오피스 코미디.",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.03.04 · 개봉",
            genre: "코미디, 드라마",
            type: "2D",
            director: "조현진",
            cast: "염혜란, 최성은, 아린, 박호산"
        ),
        MovieModel(
            title: "28년 후: 뼈의 사원",
            posterImage: "years",
            audienceCount: 300,
            englishTitle: "28 Years Later: The Bone Temple",
            quote: "\"끝나지 않은 악몽, 살아남아야 한다.\"",
            description: "분노 바이러스가 세상을 휩쓴 지 28년 후, 황폐해진 세상에서 살아남은 생존자들이 새로운 위협인 '뼈의 사원'의 비밀을 마주하며 벌어지는 처절한 생존기.",
            rating: "청소년 관람불가",
            releaseInfo: "2026.02.27 · 개봉",
            genre: "공포, 스릴러",
            type: "2D, IMAX",
            director: "대니 보일",
            cast: "킬리언 머피, 조디 코머, 애런 테일러존슨"
        )
    ]

    var upcomingMovies: [MovieModel] = [
        MovieModel(
            title: "메소드연기",
            posterImage: "method",
            audienceCount: 0,
            englishTitle: "Method Acting",
            quote: "\"진짜 나를 연기하라!\"",
            description: "코미디언 출신으로 정극 연기에 도전하지만 늘 한계에 부딪히는 무명 배우. 그가 인생 최고의 배역을 맡기 위해 일상에서도 메소드 연기를 펼치며 벌어지는 짠내 나는 휴먼 코미디.",
            rating: "12세 이상 관람가",
            releaseInfo: "2026 · 개봉 예정",
            genre: "코미디, 드라마",
            type: "2D",
            director: "이기혁",
            cast: "이동휘, 강찬희, 윤경호"
        )
    ]
    
    // 무비차트 / 상영예정 구분 enum
    enum MovieChartType {
        case nowPlaying
        case upcoming
    }

    // 선택된 차트 타입에 따라 영화 목록 반환
    func currentMovies(for type: MovieChartType) -> [MovieModel] {
        switch type {
        case .nowPlaying: return movies
        case .upcoming: return upcomingMovies
        }
    }

    let theaters: [TheaterModel] = [
        TheaterModel(logo: "Dolby Cinema 로고", card: "Dolby Cinema", name: "Dolby Cinema", title: "DOLBY CINEMA", description: "완벽한 영화 관람을 완성하는\n하이엔드 시네마"),
        TheaterModel(logo: "Dolby Atmos 로고", card: "Dolby Vision+Atmos", name: "Dolby Atmos", title: "DOLBY VISION+ATMOS", description: "돌비 시네마의 선명한 영상과 입도 높은 사운드,\n직접마주하는 대형 프리미엄 클래스"),
        TheaterModel(logo: "MX4D 로고", card: "MX4D", name: "MX4D", title: "MEGA | MX4D", description: "다이나믹 이펙트가 선사하는\n새로운 영화 체험"),
        TheaterModel(logo: "LED 로고", card: "LED", name: "LED", title: "MEGA | LED", description: "부분대비 명암비, 완벽한 원시 재현력"),
        TheaterModel(logo: "Boutique Private 로고", card: "Boutique Private", name: "Boutique Private", title: "BOUTIQUE PRIVATE by MEGA", description: "오직 나와 소중한 사람들을 위한\n프라이빗한 극장 경험"),
        TheaterModel(logo: "Boutique Suite 로고", card: "Boutique Suite", name: "Boutique Suite", title: "BOUTIQUE SUITE by MEGA", description: "별업 패키지가 더해진\n럭셔리한 공간 경험"),
        TheaterModel(logo: "Boutique 로고", card: "Boutique", name: "Boutique", title: "BOUTIQUE by MEGA", description: "섬세하게 디자인된 감각적인\n극장 경험"),
        TheaterModel(logo: "Le Recliner 로고", card: "Le Recliner", name: "Le Recliner", title: "LE RECLINER by MEGA", description: "편통한 리클라이너 시스템이 구현하는\n극장의 편안함"),
        TheaterModel(logo: "Comfort 로고", card: "Comfort", name: "Comfort", title: "COMFORT by MEGA", description: "안으로 배려와 누리는\n더 편리한 영화 경험"),
    ]
}
