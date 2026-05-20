import ProjectDescription

let workspace = Workspace(
    name: "UMC_Study",
    projects: [
        "**" // 모든 하위 디렉토리의 Project.swift를 찾아서 포함시킴
    ]
)
