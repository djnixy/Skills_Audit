$x = 1
$y = 1
$z = 1

def sql(exam_no, questions)
  i = 0 
  puts 'execute "insert into exam_questions values ('+$x.to_s+','+exam_no.to_s+','+1.to_s+','+i.to_s+', null, null);"'
  for q in questions
    i += 1
    $x += 1
    puts 'execute "insert into exam_questions values ('+$x.to_s+','+exam_no.to_s+','+q.to_s+','+i.to_s+', null, null);"'
  end
  $x +=1
end

def ex(ex_no, ex_name)
  puts 'execute "insert into exams values ('+ex_no.to_s+', \''+ex_name.to_s+'\', 1, 1, 1, 1, null, null);"'
end

def question(question_path, master_id="null")
  puts 'execute "insert into questions values ('+$z.to_s+', 0, \'#{File.open(\'public/xml/'+question_path.to_s+'.xml\').read}\','+master_id.to_s+', null, null);"'
  $z += 1
end

def make(ex_name, questions=[])
  questions = Array.new(questions)
  ex($y, ex_name)
  sql($y, questions)
  puts ""
  puts ""
  $y +=1
end

question('e1JobsInvolvingShiftworkPassage')
question('e1q1Shiftwork')
question('e1q2Shiftwork')
question('e1q3Shiftwork')
question('e1q4Shiftwork')
question('e1q5Shiftwork')
question('e1q6Shiftwork')
question('e1q7Shiftwork')
question('e1q8Shiftwork')
question('e1q9Shiftwork')


make('Random Test', [2,3,4,5,6,7])
make('Quite random Test', [2,3,4,5,6,7,8,9,10,11,12,13,14,15])
make('aaaaaaaa', [3,4,5])
make('blah', [3,4,5,6,7,8,9,10])
make('Culinary', [8,12,17,32])
