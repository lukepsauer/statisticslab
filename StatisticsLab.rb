#Retrive input from user
puts "What units for domain are you using?(singular)"
domainUnits = gets.to_s
puts "What is the input file directory?(end with .csv)"
inputDirectory = gets.to_s.chomp
puts "What would you like the output directory to be called(end with a .dat)?"
outputDirectory = gets.to_s.chomp
puts outputDirectory
puts inputDirectory
puts domainUnits
#Retrive input from file
f = File.new(inputDirectory, "r")
input = f.readlines
#Seperate the arrays
input = input.map {|input| input.chomp}
stats = input.collect do |split|
	split = split.split(",")
	split[1].to_i
end
year = input.collect do |year|
	year = year.split(",")
	year[0].to_s
end
#Close file
f.close
#Calculate the mean
sum = stats.inject{|sum,x| sum + x }
statsLength = stats.length
mean =  sum / statsLength
#Calculate the standard deviation
difference = stats.collect do |difference|
	multipleDifferences = difference - mean
	differenceSquared = multipleDifferences ** 2
end
sumOfDifferencesSquared = difference.inject{|sumOfDifferencesSquared,x| sumOfDifferencesSquared + x }
variance = sumOfDifferencesSquared / statsLength
standardDeviation = (variance ** 0.5).to_f
#Open Create and clear the output file
f = File.new("#{outputDirectory}", "a+")
f.close
f = File.new("#{outputDirectory}", "w")
f.puts ""
f.close
#Open the utput file as an append plus
f = File.new("#{outputDirectory}", "a+")
#Calculate and output z-scores and years
yearTest = 0
zScore = stats.each do |zScore|
	zScores = (zScore - mean)/standardDeviation
	puts "Z-score of the year #{year[yearTest]}, is: #{zScores.round(5)}"
	f.puts "Z-score of the year #{year[yearTest]}, is: #{zScores.round(5)}"
	yearTest = yearTest + 1
end
#Calculate and output the mean, mode, range, and median
puts "The mean is: #{mean}."
f.puts "The mean is: #{mean}."
freq = stats.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
mode = stats.max_by { |v| freq[v] }
puts "The mode is: #{mode}."
f.puts "The mode is: #{mode}."
statsOrder = stats.sort
range = (statsOrder[(statsLength - 1)] - statsOrder[0])
puts "The range is: #{range}."
f.puts "The range is: #{range}."
statsMedian = statsOrder
while statsMedian.length > 2
	statsMedian.pop
	statsMedian.shift
end
if statsMedian == 2
	median = (statsMedian[0] + statsMedian[1])/2
else
	median = statsMedian[0]
end
puts "The median is: #{median}."
f.puts "The median is: #{median}."
