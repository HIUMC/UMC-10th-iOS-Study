import Foundation

@Observable
class HomeViewModel {
    var movies: [MovieModel] = [
        MovieModel(
            title: "왕과 사는 남자",
            englishTitle: "The King's Warden",
            posterImage: "kingsWarden",
            audienceCount: 1475,
            quote: "\"나는 이제 어디로 갈까요...\"",
            description: "계유정난이 조선을 뒤흔들고\n어린 왕 이유원은 왕위에서 쫓겨나 유배길에 오른다.\n\"닿은 숲을 보더라도 그 대감을 우리 광전골로 오게 해야지\"\n한편, 강원도 영월 산골 마을 광전골의 촌장 염용도는 먹고 살기 힘든 마을 사람들을 위해 정영포를 유배지로 만들기 위해 노력한다.",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.02.04 · 개봉 · 117분",
            genre: "드라마, 사극",
            type: "2D, 2D ATMOS, 디지털영문자막",
            director: "장항준",
            cast: "유해진, 박지훈, 유지태, 전미도, 김민, 박지환, 이준혁, 한재홍"
        ),
        MovieModel(
            title: "프로젝트 헤일메리",
            englishTitle: "Project Hail Mary",
            posterImage: "project",
            audienceCount: 56,
            quote: "\"우리는 이 미션을 완수해야 합니다.\"",
            description: "태양이 서서히 죽어가고 있다. 지구를 구하기 위해 홀로 우주로 보내진 과학자 라일랜드 그레이스. 기억을 잃은 채 깨어난 그는 인류의 마지막 희망을 짊어지고 미지의 외계 생명체와 함께 불가능한 미션에 도전한다.",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.03.15 · 개봉 · 142분",
            genre: "SF, 드라마",
            type: "2D, IMAX, 4DX",
            director: "필 로드",
            cast: "라이언 고슬링, 산드라 불럭"
        ),
        MovieModel(
            title: "호퍼스",
            englishTitle: "Hoppers",
            posterImage: "hoppers",
            audienceCount: 0,
            quote: "\"뛰어! 더 높이!\"",
            description: "평범한 토끼 가족이 예상치 못한 모험에 휘말리며 펼쳐지는 유쾌한 애니메이션.",
            rating: "전체 관람가",
            releaseInfo: "2026.04.01 · 개봉 · 95분",
            genre: "애니메이션, 코미디",
            type: "2D, 더빙, 자막",
            director: "크리스 벅",
            cast: "성우: 이광수, 박보영"
        ),
        MovieModel(
            title: "어쩔수가없다",
            englishTitle: "Mad Dance",
            posterImage: "madDance",
            audienceCount: 20,
            quote: "\"춤추지 않으면 죽는다.\"",
            description: "전설의 댄서였던 주인공이 은퇴 후 평범한 삶을 살다가, 우연히 지하 댄스 배틀에 휘말리면서 다시 한번 무대 위에 서게 되는 이야기.",
            rating: "15세 이상 관람가",
            releaseInfo: "2026.03.20 · 개봉 · 108분",
            genre: "액션, 코미디",
            type: "2D, 2D ATMOS",
            director: "류승완",
            cast: "마동석, 이정재, 정해인"
        ),
        MovieModel(
            title: "극장판 귀멸의 인피니티 캐슬",
            englishTitle: "Demon Slayer: Infinity Castle",
            posterImage: "humint",
            audienceCount: 1,
            quote: "\"전집중... 물의 호흡!\"",
            description: "무한성 안에서 펼쳐지는 귀살대와 키부츠지 무잔의 최후의 전투. 탄지로와 동료들은 인류를 지키기 위해 목숨을 건 싸움에 나선다.",
            rating: "15세 이상 관람가",
            releaseInfo: "2026.03.28 · 개봉 · 130분",
            genre: "애니메이션, 액션",
            type: "2D, IMAX, 4DX, ATMOS",
            director: "소토자키 하루오",
            cast: "성우: 하나에 나츠키, 시모노 히로"
        ),
        MovieModel(
            title: "F1 더 무비",
            englishTitle: "F1",
            posterImage: "method",
            audienceCount: 0,
            quote: "\"속도의 끝에서 나를 찾았다.\"",
            description: "은퇴한 전설의 F1 드라이버가 다시 한번 서킷에 복귀하여 새로운 팀과 함께 챔피언십에 도전하는 이야기.",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.04.10 · 개봉 · 135분",
            genre: "액션, 스포츠",
            type: "2D, IMAX",
            director: "조셉 코신스키",
            cast: "브래드 피트, 다미안 루이스"
        ),
        MovieModel(
            title: "오래된 미래",
            englishTitle: "Ancient Futures",
            posterImage: "years",
            audienceCount: 0,
            quote: "\"과거에서 미래의 답을 찾다.\"",
            description: "히말라야 산맥 깊숙한 곳, 수천 년간 자연과 공존해온 마을의 이야기를 통해 현대 문명이 잃어버린 것들을 되돌아보는 다큐멘터리.",
            rating: "전체 관람가",
            releaseInfo: "2026.04.15 · 개봉 · 98분",
            genre: "다큐멘터리",
            type: "2D",
            director: "헬레나 노르베리 호지",
            cast: "-"
        ),
    ]
}
