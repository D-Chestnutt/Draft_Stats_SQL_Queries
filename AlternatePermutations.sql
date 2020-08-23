Drop Table EntrantGameWeek
Select GWP.GameWeek, GWP.EntrantId, SUM(PW.TotalPoints) GameWeekPoints Into EntrantGameWeek From GameWeekPick GWP
Join PlayerWeek PW on GWP.Element = PW.PlayerId and GWP.GameWeek = PW.GameWeek
Where GWP.Position < 12
and PW.TotalPoints <> 0
Group By GWP.EntrantId, GWP.GameWeek
Having SUM(PW.TotalPoints) > 0
Order by GWP.GameWeek, GWP.EntrantId

--Select Distinct GameWeek From EntrantGameWeek

Update EntrantGameWeek
Set GameWeek = GameWeek -9
Where GameWeek > 29
Begin

Declare @fixtureOne int = 0; 
Declare @fixtureTwo int = 0;
Declare @fixtureThree int = 0;
Declare @fixtureFour int = 0;
Declare @fixtureFive int = 0;
Declare @fixtureSix int = 0;
Declare @fixtureSeven int = 0;
Declare @fixtureEight int = 0;

Declare @Permutation int = 0;

If OBJECT_ID('tempdb..#AlternatePermutations') is not null
	Drop Table #AlternatePermutations

Create Table #AlternatePermutations(
	Permutation Int,
	FixtureNo Int,
	EntrantId Int,
	EntrantPoints Int
);



While (Select Min(Id) From Entrant Where id > @fixtureOne) is not null
BEGIN
	Set @fixtureOne = (Select Min(Id) From Entrant Where id > @fixtureOne);

	If OBJECT_ID('tempdb..#entrantTwo') is not null
		Drop Table #entrantTwo
	
	Select * Into #entrantTwo From Entrant Where id not in (@fixtureOne);

	While (Select Min(Id) From #entrantTwo Where id > @fixtureTwo) is not null
	BEGIN
		Set @fixtureTwo = (Select Min(Id) From #entrantTwo Where id > @fixtureTwo);

		If OBJECT_ID('tempdb..#entrantThree') is not null
		Drop Table #entrantThree
		
		Select * Into #entrantThree From Entrant Where id not in (@fixtureOne, @fixtureTwo);

		While (Select Min(Id) From #entrantThree Where id > @fixtureThree) is not null
		BEGIN
			Set @fixtureThree = (Select Min(Id) From #entrantThree Where id > @fixtureThree);

			If OBJECT_ID('tempdb..#entrantFour') is not null
				Drop Table #entrantFour
		
		Select * Into #entrantFour From Entrant Where id not in (@fixtureOne, @fixtureTwo, @fixtureThree);

			While (Select Min(Id) From #entrantFour Where id > @fixtureFour) is not null
			BEGIN
				Set @fixtureFour = (Select Min(Id) From #entrantFour Where id > @fixtureFour);

				If OBJECT_ID('tempdb..#entrantFive') is not null
					Drop Table #entrantFive
		
				Select * Into #entrantFive From Entrant Where id not in (@fixtureOne, @fixtureTwo, @fixtureThree, @fixtureFour);

				While (Select Min(Id) From #entrantFive Where id > @fixtureFive) is not null
				BEGIN
					Set @fixtureFive = (Select Min(Id) From #entrantFive Where id > @fixtureFive);

					If OBJECT_ID('tempdb..#entrantSix') is not null
						Drop Table #entrantSix
		
					Select * Into #entrantSix From Entrant Where id not in (@fixtureOne, @fixtureTwo, @fixtureThree, @fixtureFour, @fixtureFive);

					While (Select Min(Id) From #entrantSix Where id > @fixtureSix) is not null
					BEGIN
						Set @fixtureSix = (Select Min(Id) From #entrantSix Where id > @fixtureSix);

						If OBJECT_ID('tempdb..#entrantSeven') is not null
							Drop Table #entrantSeven
		
						Select * Into #entrantSeven From Entrant Where id not in (@fixtureOne, @fixtureTwo, @fixtureThree, @fixtureFour, @fixtureFive, @fixtureSix);

						While (Select Min(Id) From #entrantSeven Where id > @fixtureSeven) is not null
						BEGIN
							Set @fixtureSeven = (Select Min(Id) From #entrantSeven Where id > @fixtureSeven);
							Set @fixtureEight = (Select Id From Entrant Where id not in (@fixtureOne, @fixtureTwo, @fixtureThree, @fixtureFour, @fixtureFive, @fixtureSix, @fixtureSeven));

							Declare @week int = 1;

							Declare @PointsOne int = 0;
							Declare @PointsTwo int = 0;
							Declare @PointsThree int = 0;
							Declare @PointsFour int = 0;
							Declare @PointsFive int = 0;
							Declare @PointsSix int = 0;
							Declare @PointsSeven int = 0;
							Declare @PointsEight int = 0;

							Set @Permutation = @Permutation + 1;

							While Exists (Select GameWeekPoints From EntrantGameWeek Where GameWeek = @week)
							BEGIN
								
								Declare @gwOne int = (Select GameWeekPoints From EntrantGameWeek Where EntrantId = @fixtureOne and GameWeek = @week);
								Declare @gwTwo int = (Select GameWeekPoints From EntrantGameWeek Where EntrantId = @fixtureTwo and GameWeek = @week)
								Declare @gwThree int = (Select GameWeekPoints From EntrantGameWeek Where EntrantId = @fixtureThree and GameWeek = @week)
								Declare @gwFour int = (Select GameWeekPoints From EntrantGameWeek Where EntrantId = @fixtureFour and GameWeek = @week)
								Declare @gwFive int = (Select GameWeekPoints From EntrantGameWeek Where EntrantId = @fixtureFive and GameWeek = @week)
								Declare @gwSix int = (Select GameWeekPoints From EntrantGameWeek Where EntrantId = @fixtureSix and GameWeek = @week)
								Declare @gwSeven int = (Select GameWeekPoints From EntrantGameWeek Where EntrantId = @fixtureSeven and GameWeek = @week)
								Declare @gwEight int = (Select GameWeekPoints From EntrantGameWeek Where EntrantId = @fixtureEight and GameWeek = @week)

								if (@week % 7) = 0
								BEGIN
										if @gwOne > @gwTwo
											Set @PointsOne = @PointsOne + 3
										else if @gwOne < @gwTwo
											Set @PointsTwo = @PointsTwo + 3
										else
										BEGIN
											Set @PointsOne = @PointsOne + 1
											Set @PointsTwo = @PointsTwo + 1
										END

										if @gwThree > @gwSeven
											Set @PointsThree = @PointsThree + 3
										else if @gwThree < @gwSeven
											Set @PointsSeven = @PointsSeven + 3
										else
										BEGIN
											Set @PointsSeven = @PointsSeven + 1
											Set @PointsThree = @PointsThree + 1
										END

										if @gwSix > @gwFour
											Set @PointsSix = @PointsSix + 3
										else if @gwSix < @gwFour
											Set @PointsFour = @PointsFour + 3
										else
										BEGIN
											Set @PointsSix = @PointsSix + 1
											Set @PointsFour = @PointsFour + 1
										END

										if @gwFive > @gwEight
											Set @PointsFive = @PointsFive + 3
										else if @gwFive < @gwEight
											Set @PointsEight = @PointsEight + 3 
										else
										BEGIN
											Set @PointsEight = @PointsEight + 1
											Set @PointsFive = @PointsFive + 1
										END
									END

									if (@week % 7) = 1
									BEGIN
										if @gwOne > @gwEight
											Set @PointsOne = @PointsOne + 3
										else if @gwOne < @gwEight
											Set @PointsEight = @PointsEight + 3
										else
										BEGIN
											Set @PointsEight = @PointsEight + 1
											Set @PointsOne = @PointsOne + 1
										END

										if @gwTwo > @gwSeven
											Set @PointsTwo = @PointsTwo + 3
										else if @gwTwo < @gwSeven
											Set @PointsSeven = @PointsSeven + 3
										else
										BEGIN
											Set @PointsSeven = @PointsSeven + 1
											Set @PointsTwo = @PointsTwo + 1
										END


										if @gwThree > @gwSix
											Set @PointsThree = @PointsThree + 3
										else if @gwThree < @gwSix
											Set @PointsSix = @PointsSix + 3
										else
										BEGIN
											Set @PointsSix = @PointsSix + 1
											Set @PointsThree = @PointsThree + 1
										END

										if @gwFour > @gwFive
											Set @PointsFour = @PointsFour + 3
										else if @gwFour < @gwFive
											Set @PointsFive = @PointsFive + 3
										else
										BEGIN
											Set @PointsFive = @PointsFive + 1
											Set @PointsFour = @PointsFour + 1
										END
									END

									if (@week % 7) = 2
									BEGIN
										if @gwOne > @gwSeven
											Set @PointsOne = @PointsOne + 3
										else if @gwOne < @gwSeven
											Set @PointsSeven = @PointsSeven + 3
										else
										BEGIN
											Set @PointsOne = @PointsOne + 1
											Set @PointsSeven = @PointsSeven + 1
										END

										if @gwSix > @gwTwo
											Set @PointsSix = @PointsSix + 3
										else if @gwSix < @gwTwo
											Set @PointsTwo = @PointsTwo + 3
										else
										BEGIN
											Set @PointsTwo = @PointsTwo + 1
											Set @PointsSix = @PointsSix + 1
										END

										if @gwFive > @gwThree
											Set @PointsFive = @PointsFive + 3
										else if @gwFive < @gwThree
											Set @PointsThree = @PointsThree + 3
										else
										BEGIN
											Set @PointsFive = @PointsFive + 1
											Set @PointsThree = @PointsThree + 1
										END

										if @gwEight > @gwFour
											Set @PointsEight = @PointsEight + 3
										else if @gwEight < @gwFour
											Set @PointsFour = @PointsFour + 3
										else
										BEGIN
											Set @PointsFour = @PointsFour + 1
											Set @PointsEight = @PointsEight + 1
										END
									END

									if (@week % 7) = 3
									BEGIN
										if @gwOne > @gwSix
											Set @PointsOne = @PointsOne + 3
										else if @gwOne < @gwSix
											Set @PointsSix = @PointsSix + 3
										else
										BEGIN
											Set @PointsSix = @PointsSix + 1
											Set @PointsOne = @PointsOne + 1
										END

										if @gwTwo > @gwFive
											Set @PointsTwo = @PointsTwo + 3
										else if @gwTwo < @gwFive
											Set @PointsFive = @PointsFive + 3
										else
										BEGIN
											Set @PointsFive = @PointsFive + 1
											Set @PointsTwo = @PointsTwo + 1
										END

										if @gwThree > @gwFour
											Set @PointsThree = @PointsThree + 3
										else if @gwThree < @gwFour
											Set @PointsFour = @PointsFour + 3
										else
										BEGIN
											Set @PointsThree = @PointsThree + 1
											Set @PointsFour = @PointsFour + 1
										END

										if @gwSeven > @gwEight
											Set @PointsSeven = @PointsSeven + 3
										else if @gwSeven < @gwEight
											Set @PointsEight = @PointsEight + 3
										else
										BEGIN
											Set @PointsEight = @PointsEight + 1
											Set @PointsSeven = @PointsSeven + 1
										END
									END

									if (@week % 7) = 4
									BEGIN
										if @gwFive > @gwOne
											Set @PointsFive = @PointsFive + 3
										else if @gwFive < @gwOne
											Set @PointsOne = @PointsOne + 3
										else
										BEGIN
											Set @PointsOne = @PointsOne + 1
											Set @PointsFive = @PointsFive + 1
										END

										if @gwTwo > @gwFour
											Set @PointsTwo = @PointsTwo + 3
										else if @gwTwo < @gwFour
											Set @PointsFour = @PointsFour + 3
										else
										BEGIN
											Set @PointsFour = @PointsFour + 1
											Set @PointsTwo = @PointsTwo + 1
										END

										if @gwThree > @gwEight
											Set @PointsThree = @PointsThree + 3
										else if @gwThree < @gwEight
											Set @PointsEight = @PointsEight + 3
										else
										BEGIN
											Set @PointsThree = @PointsThree + 1
											Set @PointsEight = @PointsEight + 1
										END

										if @gwSeven > @gwSix
											Set @PointsSeven = @PointsSeven + 3
										else if @gwSeven < @gwSix
											Set @PointsSix = @PointsSix + 3
										else
										BEGIN
											Set @PointsSix = @PointsSix + 1
											Set @PointsSeven = @PointsSeven + 1
										END
									END

									if (@week % 7) = 5				
									BEGIN
										if @gwFour > @gwOne
											Set @PointsFour = @PointsFour + 3
										else if @gwFour < @gwOne
											Set @PointsOne = @PointsOne + 3
										else
										BEGIN
											Set @PointsOne = @PointsOne + 1
											Set @PointsFour = @PointsFour + 1
										END

										if @gwTwo > @gwThree
											Set @PointsTwo = @PointsTwo + 3
										else if @gwTwo < @gwThree
											Set @PointsThree = @PointsThree + 3
										else
										BEGIN
											Set @PointsThree = @PointsThree + 1
											Set @PointsTwo = @PointsTwo + 1
										END

										if @gwSeven > @gwFive
											Set @PointsSeven = @PointsSeven + 3
										else if @gwSeven < @gwFive
											Set @PointsFive = @PointsFive + 3
										else
										BEGIN
											Set @PointsSeven = @PointsSeven + 1
											Set @PointsFive = @PointsFive + 1
										END

										if @gwEight > @gwSix
											Set @PointsEight = @PointsEight + 3
										else if @gwEight < @gwSix
											Set @PointsSix = @PointsSix + 3
										else
										BEGIN
											Set @PointsSix = @PointsSix + 1
											Set @PointsEight = @PointsEight + 1
										END

									END

									if (@week % 7) = 6
									BEGIN
										if @gwThree > @gwOne
											Set @PointsThree = @PointsThree + 3
										else if @gwThree < @gwOne
											Set @PointsOne = @PointsOne + 3
										else
										BEGIN
											Set @PointsOne = @PointsOne + 1
											Set @PointsThree = @PointsThree + 1
										END

										if @gwTwo > @gwEight
											Set @PointsTwo = @PointsTwo + 3
										else if @gwTwo < @gwEight
											Set @PointsEight = @PointsEight + 3
										else
										BEGIN
											Set @PointsEight = @PointsEight + 1
											Set @PointsTwo = @PointsTwo + 1
										END

										if @gwSeven > @gwFour
											Set @PointsSeven = @PointsSeven + 3
										else if @gwSeven < @gwFour
											Set @PointsFour = @PointsFour + 3
										else
										BEGIN
											Set @PointsSeven = @PointsSeven + 1
											Set @PointsFour = @PointsFour + 1
										END 

										if @gwFive > @gwSix
											Set @PointsFive = @PointsFive + 3
										else if @gwFive < @gwSix
											Set @PointsSix = @PointsSix + 3
										else
										BEGIN
											Set @PointsSix = @PointsSix + 1
											Set @PointsFive = @PointsFive + 1
										END
									END

									Set @week = @week + 1
								END

								Insert Into #AlternatePermutations (
									Permutation,
									FixtureNo,
									EntrantId,
									EntrantPoints
								)
								Values (
									@Permutation, 
									1, 
									@fixtureOne, 
									@PointsOne
								),
								(
									@Permutation, 
									2, 
									@fixtureTwo, 
									@PointsTwo
								),
								(
									@Permutation, 
									3, 
									@fixtureThree, 
									@PointsThree
								),
								(
									@Permutation, 
									4, 
									@fixtureFour, 
									@PointsFour
								),
								(
									@Permutation, 
									5, 
									@fixtureFive, 
									@PointsFive
								),
								(
									@Permutation, 
									6, 
									@fixtureSix, 
									@PointsSix
								),
								(
									@Permutation, 
									7, 
									@fixtureSeven, 
									@PointsSeven
								),
								(
									@Permutation, 
									8, 
									@fixtureEight, 
									@PointsEight
								);

								PRINT @Permutation

						END

						Set @fixtureSeven = 0;
						Set @fixtureEight = 0;
					END

					Set @fixtureSix = 0;
					Set @fixtureSeven = 0;
					Set @fixtureEight = 0;
				END

				Set @fixtureFive = 0;
				Set @fixtureSix = 0;
				Set @fixtureSeven = 0;
				Set @fixtureEight = 0;
			END

			Set @fixtureFour = 0;
			Set @fixtureFive = 0;
			Set @fixtureSix = 0;
			Set @fixtureSeven = 0;
			Set @fixtureEight = 0;
		END

		Set @fixtureThree = 0;
		Set @fixtureFour = 0;
		Set @fixtureFive = 0;
		Set @fixtureSix = 0;
		Set @fixtureSeven = 0;
		Set @fixtureEight = 0;
	END

	Set @fixtureTwo = 0;
	Set @fixtureThree = 0;
	Set @fixtureFour = 0;
	Set @fixtureFive = 0;
	Set @fixtureSix = 0;
	Set @fixtureSeven = 0;
	Set @fixtureEight = 0;
END

END

Select E.EntryName, Max(EntrantPoints), Min(EntrantPoints) From #AlternatePermutations P
Join Entrant E on E.Id = P.EntrantId
Group By E.EntryName


If OBJECT_ID('db..AlternatePermutationScores') is not null
	Drop Table AlternatePermutationScores

Select AP.Permutation, AP.FixtureNo, AP.EntrantID, AP.EntrantPoints, T.FantasyPoints INTO AlternatePermutationScores
From #AlternatePermutations AP
Join TotalEntrantPoints T on T.EntrantID = AP.EntrantId

Drop table TotalEntrantPoints

Select EntrantID, SUM(GameWeekPoints) FantasyPoints INTO TotalEntrantPoints
From EntrantGameWeek 
Group By EntrantId

select max(gameweek) from EntrantGameWeek


Drop Table PermutationsRanked
Select * Into PermutationsRanked From (
	Select	
		Permutation, 
		FixtureNo, 
		EntrantId,
		EntrantPoints,
		FantasyPoints,
		Rank () Over (
			Partition By Permutation
			Order by EntrantPoints desc, FantasyPoints desc 
		) EntrantPosition
	From AlternatePermutationScores
	) t
Order by Permutation

Drop table PermutationTables
Select Distinct(AP.Permutation), 
	R1.EntrantId FirstPlace, R1.EntrantPoints FirstPoints, R1.FantasyPoints FirstFP,
	R2.EntrantId SecondPlace, R2.EntrantPoints SecondPoints, R2.FantasyPoints SecondFP,
	R3.EntrantId ThirdPlace, R3.EntrantPoints ThirdPoints, R3.FantasyPoints ThirdFP,
	R4.EntrantId FourthPlace, R4.EntrantPoints FourthPoints, R4.FantasyPoints FourthFP,
	R5.EntrantId FithPlace, R5.EntrantPoints FithPoints, R5.FantasyPoints FithFP,
	R6.EntrantId SixthPlace, R6.EntrantPoints SixthPoints, R6.FantasyPoints SixthtFP,
	R7.EntrantId SeventhPlace, R7.EntrantPoints SeventhPoints, R7.FantasyPoints SeventhFP,
	R8.EntrantId EighthPlace, R8.EntrantPoints EighthPoints, R8.FantasyPoints EighthFP
	Into PermutationTables
	From #AlternatePermutations AP 
Join PermutationsRanked R1 ON R1.Permutation = AP.Permutation and R1.EntrantPosition = 1
Join PermutationsRanked R2 ON R2.Permutation = AP.Permutation and R2.EntrantPosition = 2
Join PermutationsRanked R3 ON R3.Permutation = AP.Permutation and R3.EntrantPosition = 3
Join PermutationsRanked R4 ON R4.Permutation = AP.Permutation and R4.EntrantPosition = 4
Join PermutationsRanked R5 ON R5.Permutation = AP.Permutation and R5.EntrantPosition = 5
Join PermutationsRanked R6 ON R6.Permutation = AP.Permutation and R6.EntrantPosition = 6
Join PermutationsRanked R7 ON R7.Permutation = AP.Permutation and R7.EntrantPosition = 7
Join PermutationsRanked R8 ON R8.Permutation = AP.Permutation and R8.EntrantPosition = 8
Order by AP.Permutation desc

select * From PermutationTables
