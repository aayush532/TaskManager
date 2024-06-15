require 'rufus-scheduler'

class Task < ApplicationRecord
  belongs_to :user

  enum status: { backlog: 0, in_progress: 1, done: 2 }

  validates :deadline, :status, presence: true
  validate :deadline_must_be_valid
  after_save :schedule_alerts

  private

  def deadline_must_be_valid
    if deadline.present?
      if deadline < Time.current
        errors.add(:deadline, "can't be in the past")
      elsif deadline < 12.hours.from_now
        errors.add(:deadline, "must be at least 12 hours from now")
      end
    end
  end

  def schedule_alerts
    return if deadline.nil?
    scheduler = Rufus::Scheduler.singleton
    
    scheduler.jobs(tag: "task_#{id}_day").each(&:unschedule)
    scheduler.jobs(tag: "task_#{id}_hour").each(&:unschedule)
    
    schedule_job(deadline - 1.day, "task_#{id}_day")
    schedule_job(deadline - 1.hour, "task_#{id}_hour")
  end

  def schedule_job(time_to_run, tag)
    scheduler = Rufus::Scheduler.singleton
    scheduler.at time_to_run, tag: tag do
      process_task(id, tag)
    end
  end

  def process_task(task_id, tag)
    task = Task.find_by(id: task_id)
    return if task.blank? || task.status == 'done'
    
    puts "Processing task: #{task.title}, Tag: #{tag}"
    TaskMailer.deadline_alert(task).deliver_now
  end
end
