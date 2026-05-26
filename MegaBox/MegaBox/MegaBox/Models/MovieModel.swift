import Foundation

struct MovieModel: Identifiable, Hashable {
    let id: String

    // 홈 화면
    let title: String
    let posterImage: String
    let posterURL: URL?
    let backdropURL: URL?
    let audienceCount: Int
    
    // 영화 상세 화면
    let englishTitle: String
    let quote: String
    let description: String
    let ageRating: String
    let releaseInfo: String
    let genre: String
    let type: String
    let director: String
    let cast: String

    init(
        id: String,
        title: String,
        posterImage: String,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        audienceCount: Int,
        englishTitle: String,
        quote: String,
        description: String,
        ageRating: String,
        releaseInfo: String,
        genre: String,
        type: String,
        director: String,
        cast: String
    ) {
        self.id = id
        self.title = title
        self.posterImage = posterImage
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.audienceCount = audienceCount
        self.englishTitle = englishTitle
        self.quote = quote
        self.description = description
        self.ageRating = ageRating
        self.releaseInfo = releaseInfo
        self.genre = genre
        self.type = type
        self.director = director
        self.cast = cast
    }

    
    // 관객수를 "누적관객수 1000만" 형식으로 포맷팅
    var formattedAudienceCount: String {
        if audienceCount == 0 {
            return "누적관객수 0"
        }
        return "누적관객수 \(audienceCount)만"
    }
}

extension MovieModel {
    static let allMovies: [MovieModel] = [
        MovieModel(
            id: "kings-warden",
            title: "왕과 사는 남자",
            posterImage: "kingsWarden",
            audienceCount: 1000,
            englishTitle: "The King's Warden",
            quote: "\"닿은 숲을 보더라도 그 대감을 우리 광전골로 오게 해야지.\"",
            description: "계유정난이 조선을 뒤흔들고, 어린 왕 단종이 왕위에서 쫓겨나 유배길에 오른다. 강원도 영월 산골 마을 광전골의 촌장 조유례와 엄흥도는 먹고살기 힘든 마을 사람들을 위해 정영포를 유배지로 만들려 고군분투한다.",
            ageRating: "12세 이상 관람가",
            releaseInfo: "2026.02.04 · 개봉 · 117분",
            genre: "드라마, 사극",
            type: "2D",
            director: "장항준",
            cast: "유해진, 박지훈, 유지태, 전미도, 안재홍, 김민"
        ),
        MovieModel(
            id: "project-hail-mary",
            title: "프로젝트 헤일메리",
            posterImage: "project",
            audienceCount: 120,
            englishTitle: "Project Hail Mary",
            quote: "\"이 미션은 나 혼자만의 것이 아니다.\"",
            description: "태양이 서서히 죽어가고 있는 위기 속, 기억을 잃은 채 우주선에서 깨어난 과학자 라일랜드 그레이스가 인류를 멸망에서 구하기 위해 미지의 외계 생명체와 협력하여 불가능한 미션에 도전하는 SF 생존 스릴러.",
            ageRating: "12세 이상 관람가",
            releaseInfo: "2026.03.18 · 개봉 · 142분",
            genre: "SF, 스릴러",
            type: "2D, IMAX, 4DX",
            director: "필 로드, 크리스토퍼 밀러",
            cast: "라이언 고슬링, 산드라 휠러"
        ),
        MovieModel(
            id: "hoppers",
            title: "호퍼스",
            posterImage: "hoppers",
            audienceCount: 210,
            englishTitle: "Hoppers",
            quote: "\"완벽한 비버의 삶 속으로!\"",
            description: "동물들의 뇌에 인간의 의식을 전송하는 최첨단 기술을 통해 비버의 삶을 살게 된 인간 소녀 메이블. 동물들의 세계에 깊숙이 잠입하면서 펼쳐지는 유쾌한 픽사 애니메이션.",
            ageRating: "전체 관람가",
            releaseInfo: "2026.03.04 · 개봉 · 104분",
            genre: "애니메이션, 코미디",
            type: "2D, 더빙, 자막",
            director: "대니얼 총",
            cast: "성우: 파이퍼 커다, 바비 모니한, 존 햄"
        ),
        MovieModel(
            id: "humint",
            title: "휴민트",
            posterImage: "humint",
            audienceCount: 450,
            englishTitle: "HUMINT",
            quote: "\"누구도 믿을 수 없는 첩보전이 시작된다.\"",
            description: "블라디보스토크 국경에서 발생하는 범죄를 파헤치기 위해 나선 남북한 비밀 요원들이 서로 충돌하며 벌어지는 첩보 액션 영화.",
            ageRating: "15세 이상 관람가",
            releaseInfo: "2026.04 · 개봉 예정",
            genre: "액션, 스파이",
            type: "2D, IMAX",
            director: "류승완",
            cast: "조인성, 박정민, 박해준, 나나"
        ),
        MovieModel(
            id: "mad-dance-office",
            title: "매드댄스오피스",
            posterImage: "madDance",
            audienceCount: 85,
            englishTitle: "Mad Dance Office",
            quote: "\"스텝을 밟으니 인생이 풀린다!\"",
            description: "승진을 위해 열정을 불태우는 완벽주의 직장인, 하지만 스트레스는 최고조! 우연히 동네 댄스 학원에 등록하게 되면서 춤을 통해 인생의 새로운 스텝을 밟아가는 유쾌한 오피스 코미디.",
            ageRating: "12세 이상 관람가",
            releaseInfo: "2026.03.04 · 개봉",
            genre: "코미디, 드라마",
            type: "2D",
            director: "조현진",
            cast: "염혜란, 최성은, 아린, 박호산"
        ),
        MovieModel(
            id: "method-acting",
            title: "메소드연기",
            posterImage: "method",
            audienceCount: 0,
            englishTitle: "Method Acting",
            quote: "\"진짜 나를 연기하라!\"",
            description: "코미디언 출신으로 정극 연기에 도전하지만 늘 한계에 부딪히는 무명 배우. 그가 인생 최고의 배역을 맡기 위해 일상에서도 메소드 연기를 펼치며 벌어지는 짠내 나는 휴먼 코미디.",
            ageRating: "12세 이상 관람가",
            releaseInfo: "2026 · 개봉 예정",
            genre: "코미디, 드라마",
            type: "2D",
            director: "이기혁",
            cast: "이동휘, 강찬희, 윤경호"
        ),
        MovieModel(
            id: "28-years-later-bone-temple",
            title: "28년 후: 뼈의 사원",
            posterImage: "years",
            audienceCount: 300,
            englishTitle: "28 Years Later: The Bone Temple",
            quote: "\"끝나지 않은 악몽, 살아남아야 한다.\"",
            description: "분노 바이러스가 세상을 휩쓴 지 28년 후, 황폐해진 세상에서 살아남은 생존자들이 새로운 위협인 '뼈의 사원'의 비밀을 마주하며 벌어지는 처절한 생존기.",
            ageRating: "청소년 관람불가",
            releaseInfo: "2026.02.27 · 개봉",
            genre: "공포, 스릴러",
            type: "2D, IMAX",
            director: "대니 보일",
            cast: "킬리언 머피, 조디 코머, 애런 테일러존슨"
        )
    ]

    static let nowPlayingMovies: [MovieModel] = allMovies.filter { $0.id != "method-acting" }
    static let upcomingMovies: [MovieModel] = allMovies.filter { $0.id == "method-acting" }
}
