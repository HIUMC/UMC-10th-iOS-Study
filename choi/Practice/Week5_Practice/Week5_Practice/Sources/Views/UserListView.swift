import SwiftUI

struct UserListView: View {
    @State private var viewModel = UserListViewModel()
    @State private var showAddUser = false

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("로딩 중...")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "사용자 정보를 불러오지 못했습니다",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            UserRowView(user: user)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.deleteUser(id: viewModel.users[index].id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("사용자 목록")
            .toolbar {
                Button {
                    showAddUser = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddUser) {
                AddUserView { name, bio in
                    viewModel.addUser(name: name, bio: bio)
                }
            }
            .task {
                await viewModel.fetchUsers()
            }
        }
    }
}

private struct UserRowView: View {
    let user: UserModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(user.displayName)
                .font(.headline)

            Text(user.bio)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if user.isProfileComplete {
                Label("프로필 완성", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct AddUserView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var bio = ""

    let onSave: (String, String) -> Void

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("프로필") {
                    TextField("이름", text: $name)
                    TextField("자기소개", text: $bio, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("사용자 추가")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        onSave(
                            name.trimmingCharacters(in: .whitespacesAndNewlines),
                            bio.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    UserListView()
}
