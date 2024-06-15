require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task, user: user) }
  let(:valid_attributes) { attributes_for(:task, user_id: user.id) }
  let(:invalid_attributes) { attributes_for(:task, status: nil, user_id: user.id) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Task" do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post :create, params: { task: valid_attributes }
        expect(response).to redirect_to(Task.last)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Task" do
        expect {
          post :create, params: { task: invalid_attributes }
        }.to change(Task, :count).by(0)
      end

      it "renders the new template" do
        post :create, params: { task: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { title: "Updated Task Title" }
      }

      it "updates the requested task" do
        patch :update, params: { id: task.to_param, task: new_attributes }
        task.reload
        expect(task.title).to eq("Updated Task Title")
      end

      it "redirects to the task" do
        patch :update, params: { id: task.to_param, task: new_attributes }
        task.reload
        expect(response).to redirect_to(task)
      end
    end

    context "with invalid parameters" do
      it "renders the edit template" do
        patch :update, params: { id: task.to_param, task: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task_to_delete = create(:task, user: user)
      expect {
        delete :destroy, params: { id: task_to_delete.to_param }
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      delete :destroy, params: { id: task.to_param }
      expect(response).to redirect_to(tasks_url)
    end
  end

  describe "GET #edit" do
    context "when user is authorized" do
      it "returns a success response" do
        get :edit, params: { id: task.to_param }
        expect(response).to be_successful
      end
    end

    context "when user is not authorized" do
      let(:other_user) { FactoryBot.create(:user, email: "test2@example.com") }
      let(:other_task) { FactoryBot.create(:task, user: other_user) }

      it "redirects to the tasks list with an error message" do
        get :edit, params: { id: other_task.to_param }
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to match(/You are not authorized to edit this task/)
      end
    end
  end
end
