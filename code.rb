require 'csv'
csv_text = File.read('/home/puneet/Puneet/upwork/scrap_app2/public/data.csv')
csv = CSV.parse(csv_text, :headers => true)
arr=[]
csv.each_with_index do |row,i|
  puts i
  id = row[1]
  a=MarylandCampaignFinanceCommittee.where(committee_number: id).first
  if a.present?
    a.chair_full_address=a.chair_address
    a.treasurer_full_address=a.treasurer_address
    a.chair_address = row[14] 
    a.chair_city = row[15]
    a.chair_state = row[16]
    a.chair_zip = (row[17].present? ? (row[17].include?('-') ? row[17].split("-")[0].to_i : row[17]) : "")
    a.treasurer_address
    t=a.treasurer_address
    t=t.split("  ")
    a.treasurer_address = t[0]
    a.treasurer_city = t[1]
    a.treasurer_state = t[2]
    a.treasurer_zip = (t[3].present? ? (t[3].include?('-') ? t[3].split("-")[0].to_i : t[3].gsub(/\D/, '')) : "")
    a.save
  end
end


MarylandCampaignFinanceCandidate.all.each do |a|
  f = a.first_name
  l = a.last_name
  a.first_name = l
  a.last_name = f
  a.save
end
MarylandCampaignFinanceContribution.update_all(data_source_url: "https://campaignfinancemd.us/Public/ViewReceipts?theme=vista")
# a.each{|b| b.chair_full_address=b.chair_address; b.treasurer_full_address=b.treasurer_address;b.save}
