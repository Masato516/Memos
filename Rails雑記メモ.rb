
Job.where(company_id: current_company.id).each do |job|
  p job.access_reports.sum(:page_view)
end

current_company.jobs.each do |job|
  p JobAccessReport.where(job_id: job.id).sum(:page_view)
end

current_company.jobs.each do |job|
  p Job.job_access_reports
end

current_company.jobs.first.access_reports.sum(:page_view)

current_company.jobs.order("created_at DESC").page(params[:page]).map do |job|
  # @jobs_page_view = job.access_reports.calculate
  {
    page_view: job.access_reports.sum(:page_view), 
    unique_user_count: job.access_reports.sum(:unique_user_count)
  }
end

job.access_reports.sum(:page_view)

@jobs.each do |job|
  job.page_view = 1
end

@job_page_view.fetch_values(116).present? ? @job_page_view.fetch_values(116)[0] : 0

@job_page_view.has_key?(job.id) ? @job_page_view.fetch_values(job.id).first : 0

@job_page_views.has_key?(job.id) ? @job_page_views[job.id] : 0

JobAccessReport.where(job_id: current_company.jobs).group(:job_id).sum(:page_view)

JobAccessReport.where(job_id: 1..2).sum(:page_view)