/* Euphoria Logic Programming */
include std/sequence.e

integer pointer = 1
sequence facts = {}
sequence lastQuestion = ""

main()

-----------------------------------------------------------

procedure main()

  createDatabase()
  
  firstSession()
  line()
  secondSession()
  line()
  thirdSession()
  
end procedure

procedure addFact(sequence fact)
  facts = append(facts,fact)
end procedure

procedure showAnswer(sequence answer)
  integer le = length(answer)
  if le=1 then
    printf(1,"%s\n",{answer[1]})
  elsif le=2 then
    printf(1,"%s = %s\n",{answer[1],answer[2]})
  end if
end procedure

procedure showFacts()
  for i=1 to length(facts) do
    sequence currentFact = facts[i]
    integer le = length(currentFact)
    printf(1,"%s",{currentFact[1]})
    if le = 1 then
      puts(1,".")
    else
      puts(1,"(")
      for j=2 to le do
        printf(1,"%s",{currentFact[j]})
        if j=le then
          puts(1,").")
        else
          puts(1,",")
        end if
      end for
    end if
    puts(1,"\n")
  end for
end procedure

function askQuestion(sequence question)
  lastQuestion = question
  pointer = 1
  return searchFromPointer()
end function

function nextAnswer()
  return searchFromPointer()
end function

function searchFromPointer()

  integer qlen = length(lastQuestion)

  for i=pointer to length(facts) do
    
    sequence currentFact = facts[i]
    integer flen = length(currentFact)
    
    if isRule(currentFact) then
      
      integer index = 1
      for j=1 to length(currentFact) do
        if equal(":-",currentFact[j]) then
          index = j+1
          exit
        end if
      end for
      
      -- Lista pytań rozdzielonych przecinkami
      sequence questions = slice(currentFact,index,length(currentFact))
      
      questions = split(questions,{","})
      
      -- Sprawdź po kolei wszystkie warunki
      -- Jeśli wszystkie są spełnione zwróć
      -- odpowiedni wynik
      puts(1,"Warunki do spełnienia:\n")
      for j=1 to length(questions) do
      
        sequence condition = questions[j]
        print(1,condition)
        
        askQuestion(condition)
        
      end for
      puts(1,"\n--------\n")
      
    else
      
      if qlen != flen then
        continue
      else
    
        integer wrong = 0
        for j=1 to qlen do
        
          sequence currentQuestionWord = lastQuestion[j]
          sequence currentFactWord = currentFact[j]
          integer firstLetter = currentQuestionWord[1]
          
          if firstLetter >= 65 and firstLetter < 90 then
            pointer = i + 1
            return {firstLetter,currentFactWord}
          elsif not equal(currentQuestionWord,currentFactWord) then
            wrong = 1
            exit
          end if
          
        end for
      
        if not wrong then
          pointer = i + 1
          return {"True"}
        end if
      
      end if
      
    end if
    
  end for
  
  return {"False"}
  
end function

procedure createDatabase()

  addFact({"woman","mia"})
  addFact({"woman","jody"})
  addFact({"woman","yolanda"})
  addFact({"playsAirGuitar","jody"})
  addFact({"loves","vincent","mia"})
  addFact({"party"})
  addFact({"woman","mia"})
  
  addFact({"car","vw_beatle"})
  addFact({"car","ford_escort"})
  addFact({"bike","harley_davidson"})
  addFact({"red","vw_beatle"})
  addFact({"red","ford_escort"})
  addFact({"blue","harley_davidson"})
  
  addFact({"mortal","plato"})
  addFact({"human","socrates"})
  
  addFact({"fun","X",":-","red","X",",","car","X"})
  addFact({"fun","X",":-","blue","X",",","bike","X"})
  addFact({"mortal","X",":-","human","X"})
  
end procedure

procedure firstSession()

  showAnswer(askQuestion({"woman","mia"}))
  
  for i = 1 to 2 do
    showAnswer(nextAnswer())
  end for
  
end procedure

procedure secondSession()

  showAnswer(askQuestion({"woman","X"}))
  
  for i = 1 to 4 do
    showAnswer(nextAnswer())
  end for
  
end procedure

procedure thirdSession()
  showAnswer(askQuestion({"mortal","socrates"}))
end procedure

procedure line()
  puts(1,"-----------------\n")
end procedure

function isRule(sequence w)
  for i=1 to length(w) do
    if equal(w[i],":-") then
      return 1
    end if
  end for
  return 0
end function

