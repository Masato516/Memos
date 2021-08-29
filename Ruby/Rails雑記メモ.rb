
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





context "when contact_detail_value has half-width white-space" do
  it "deletes half-width white-space at the begin and end of contact_detail before_validation" do
    @board.contact_detail = " 連絡先：sample@example.ritsumei.ac.jp "  # 前後に半角のスペースがある
    @board.valid?
    expect(@board.contact_detail).to eq "連絡先：sample@example.ritsumei.ac.jp"
  end

  it "deletes half-width white-space at the begin of contact_detail before_validation" do
    @board.contact_detail = " 連絡先：sample@example.ritsumei.ac.jp"  # 前に半角のスペースがある
    @board.valid?
    expect(@board.contact_detail).to eq "連絡先：sample@example.ritsumei.ac.jp"
  end

  it "deletes half-width white-space at the end of contact_detail before_validation" do
    @board.contact_detail = "連絡先：sample@example.ritsumei.ac.jp "  # 後に半角のスペースがある
    @board.valid?
    expect(@board.contact_detail).to eq "連絡先：sample@example.ritsumei.ac.jp"
  end

  it "does not delete half-width white-space in contact_detail before_validation" do
    @board.contact_detail = "連絡先 sample@example.ritsumei.ac.jp"  # 中に半角のスペースがある
    @board.valid?
    expect(@board.contact_detail).to eq "連絡先 sample@example.ritsumei.ac.jp"
  end
end

context "when contact_detail_value has full-width white-space" do
  it "deletes full-width white-space at the begin and end of contact_detail before_validation" do
    @board.contact_detail = "　連絡先：sample@example.ritsumei.ac.jp　"  # 前後に全角のスペースがある
    @board.valid?
    expect(@board.contact_detail).to eq "連絡先：sample@example.ritsumei.ac.jp"
  end

  it "deletes full-width white-space at the begin of contact_detail before_validation" do
    @board.contact_detail = "　連絡先：sample@example.ritsumei.ac.jp"  # 前に全角のスペースがある
    @board.valid?
    expect(@board.contact_detail).to eq "連絡先：sample@example.ritsumei.ac.jp"
  end

  it "deletes full-width white-space at the end of contact_detail before_validation" do
    @board.contact_detail = "連絡先：sample@example.ritsumei.ac.jp　"  # 後に全角のスペースがある
    @board.valid?
    expect(@board.contact_detail).to eq "連絡先：sample@example.ritsumei.ac.jp"
  end

  it "does not delete full-width white-space in contact_detail before_validation" do
    @board.contact_detail = "連絡先　sample@example.ritsumei.ac.jp"  # 中に全角のスペースがある
    @board.valid?
    expect(@board.contact_detail).to eq "連絡先　sample@example.ritsumei.ac.jp"
  end
# 取得したクエリの数値毎によって出力する月を変える
def show
  # クエリパラメータ(形式:20XX-0X)で表示する年月の情報を受け取っている
  @first_day = Date.strptime(params[:date], '%Y-%m') # 表示する月の初日
  @last_day = @first_day.end_of_month # 表示する月の最終日
  @prev_month = @first_day.last_month # 表示する月の前の月
  @next_month = @first_day.next_month # 表示する月の次の月
  
  @job = current_company.jobs.find(params[:job_id]) 
  @job_page_views         = @job.access_reports
                                .where(reported_on: @first_day..@last_day)
                                .group(:reported_on)
                                .sum(:page_view)
  @job_unique_user_counts = @job.access_reports
                                .where(reported_on: @first_day..@last_day)
                                .group(:reported_on)
                                .sum(:unique_user_count)
end

def generate_uuid_token
  self.id = loop do
    random_token = SecureRandom.urlsafe_base64(nil, false)
    break random_token unless self.class.exists?(id: random_token)
  end
end



def self.configure
  yield configuration if block_given?
end

def self.configuration
  @configuration ||= RSpec::Core::Configuration.new
end

%w[
  version
  warnings

  set
  flat_map
  filter_manager
  dsl
  notifications
  reporter
  ....
].each { |name| RSpec::Support.require_rspec_core name }
