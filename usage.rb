# Copyright (C) 2018 Piford Software Limited - All Rights Reserved.
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
#

require_relative '../migrations/api/server'
require_relative '../migrations/domain/company'

EXCLUDE = [
  'Adviser-Store',
  'Clients-First',
  'Hart Grayson',
  'Piford',
]

Server.connect(silent: true).login do |session|

  dashboard = session.get('/dashboard')

  companies = session.get(dashboard[:actions][:companies])[:companies]

  data = companies.map do |co|
    co = session.get(co[:actions][:self])
    usage = session.get(co[:actions][:usage])
    cols = usage[:months].map {|m| [m[:month], m[:nuttshells].length] }
    months = {}
    usage[:months].each {|m| months[m[:month]] = m[:nuttshells].length }
    {
      name: co[:name],
      cols: cols,
      months: months
    }
  end.reject {|d| EXCLUDE.include?(d[:name]) }

  months = data.map {|d| d[:cols].map {|c| c[0]} }.flatten.sort {|a,b| Time.parse(a) <=> Time.parse(b)}.uniq

  puts "Company,#{months.map {|m| m.gsub(/^(...).*(..)$/, "\\1 \\2")}.join(',')}"

  data.each do |co|
    print "#{co[:name]},"
    puts months.map {|m| co[:months].fetch(m, 0) }.join(',')
  end

end

