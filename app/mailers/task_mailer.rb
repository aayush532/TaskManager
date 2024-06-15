class TaskMailer < ApplicationMailer
    default from: 'aayushmishra532@gmail.com'
  
    def deadline_alert(task)
      @task = task
      mail(to: @task.user.email, subject: 'Task Deadline Alert')
    end
end