class NotesController < ApplicationController
  before_action :find_project
  before_action :find_project_level_notes, only: :index
  after_action :verify_authorized

  def index
    authorize Note
  end

  def new
    authorize Note
    @note = Note.new(project: @project, user_id:, task_id: params[:task_id])
  end

  def create
    authorize Note
    @note = Note.new(project: @project, user_id:, **note_params)

    if @note.valid?
      @note.save

      redirect_to(redirect_path, notice: I18n.t("note.create.success"))
    else
      render :new
    end
  end

  def edit
    @note = Note.find(params[:id])
    authorize @note
  end

  def update
    @note = Note.find(params[:id])
    authorize @note

    @note.assign_attributes(note_params)

    if @note.valid?
      @note.save
      redirect_to redirect_path, notice: I18n.t("note.update.success")
    else
      render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    authorize @note

    @note.destroy

    redirect_to redirect_path, notice: I18n.t("note.destroy.success")
  end

  def confirm_destroy
    @note = Note.find(params[:note_id])
    authorize @note
  end

  private def redirect_path
    @note.task_level_note? ? project_task_path(@project, @note.task.id) : project_notes_path(@project)
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_project_level_notes
    @notes = Note.includes([:user]).where(project: @project).project_level_notes
  end

  private def note_params
    params.require(:note).permit(:body, :task_id)
  end
end
