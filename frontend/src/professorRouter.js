const express=require("express")
const jwt=require("jsonwebtoken")
const router = new express.Router()
const Jwt_Secret="thisisseceret";
const Model = require("./Models/userModel.js");
const level1 = require("./Models/level1.js");
const studentAccessModel = require("./Models/studentsAccess.js")
const emails = require("./emails.js");

var savedOTPS = {

};

router.post("/login", async (req,res) => {
    try{
        if(req.body){
            const {email, password} = req.body;
            const login = await Model.findByCredentials(email,password);
            console.log(login)
            if(!login.firstName){
                res.status(301).json({error: login});
                return
            }
            res.status(200).json({response: "Login success", user: login});
            return
        }
    } catch(err){
        console.log("Error while login ", err);
        res.send({error: "Wrong password or email"})
    }
})

router.post("/register", async (req,res) => {
        try{
            if(req.body){
                const user = new Model(req.body);
                await user.save();
                console.log("user ",user)
                if(user){
                   console.log("User account created");
                   res.status(200).send({response: "Account Created", user: user});
                   return 
                }
                res.status(500).send({error: "Failed To create account"});
                return 
            }
        } catch (error){
            console.log("Failed to create account");
            res.status(500).send({error: "Failed to create account"});
        }
})
router.post("/request-otp", async (req,res) => {
    try{
        if(req.body){
                const email = req.body.email
                console.log(email, req.body)
                let randomdigit = Math.floor(100000 + Math.random() * 900000);
                await emails.sendOTP(email, randomdigit)
                savedOTPS[email] = randomdigit;
                setTimeout(() => {
                    delete savedOTPS[`${email}`];
                }, 180000);
                console.log(savedOTPS);
                res.status(200).send({success: `OTP sent - ${email}`})
        }
    } catch(err){
        console.log("Error while login ", err);
        res.send({error: "Wrong password or email"})
    }
})

router.post("/check-otp", async(req,res) => {
    try{
        const {otp, email} = req.body
        if (savedOTPS[email] && savedOTPS[email].toString() === otp.toString()) {
            res.status(200).send({success : "Mail Verified"})
            delete savedOTPS[email];
          } else {
            res.status(300).send({error: "Wrong otp!"})
          }

    } catch (err) {
        console.log("Error in while checking OTP : ",err)
        res.status(500).send({error : "Something went wrong in server!"})
    }
})

router.post("/addQuestion", async (req, res) => {
    try {
        const { compound, correct, incorrect1, incorrect2, incorrect3 } = req.body;

        const newQuestion = new level1({
            compound,
            correct,
            incorrect1,
            incorrect2,
            incorrect3
        });

        await newQuestion.save();

        res.status(201).json({ ok: "Added", message: 'Question added successfully!' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error, failed to add question.' });
    }
});

router.get("/getQuestions/", async (req,res) => {
    try {
        const getQuestion = await level1.find();

        if (!getQuestion) {
            return res.status(404).json({ message: 'Questions not found.' });
        }

        res.status(200).json({  ok: "Updated", questions: getQuestion });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error, failed to update question.' });
    }
})

router.put("/questions/:questionNumber", async (req, res) => {
    try {
        console.log(req.body)
        const { compound, correct, incorrect1, incorrect2, incorrect3 } = req.body;
        const questionNumber = req.params.questionNumber;

        const updatedQuestion = await level1.findOneAndUpdate(
            { questionNumber: questionNumber },
            { compound, correct, incorrect1, incorrect2, incorrect3 },
            { new: true }
        );

        if (!updatedQuestion) {
            return res.status(404).json({ message: 'Question not found.' });
        }

        res.status(200).json({  ok: "Updated", message: 'Question updated successfully!' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error, failed to update question.' });
    }
});


router.delete("/questions/:questionNumber", async (req, res) => {
    try {
        const questionNumber = req.params.questionNumber;

        const deletedQuestion = await level1.findOneAndDelete({ questionNumber: questionNumber });

        if (!deletedQuestion) {
            return res.status(404).json({ message: 'Question not found.' });
        }

        res.status(200).json({ ok: "Deleted", message: 'Question deleted successfully!' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error, failed to delete question.' });
    }
});

router.get('/loadLevel1Questions', async (req, res) => {
    try {
        const questions = await level1.find().exec();

        const level1Data = {
            question: "Assign oxidation numbers to each atom in the following compounds and ions.",
        };

        if (Array.isArray(questions) && questions.length > 0) {
            
            const shuffledQuestions = questions.sort(() => Math.random() - 0.5);

            
            shuffledQuestions.forEach((question, index) => {
                level1Data[(index + 1).toString()] = {
                    compound: question.compound,
                    correct: question.correct,
                    incorrect1: question.incorrect1,
                    incorrect2: question.incorrect2,
                    incorrect3: question.incorrect3
                };
            });
        } else {
            console.error("Questions data is not valid.");
            return res.status(400).json({ error: "Invalid questions data." });
        }

        res.status(200).json(level1Data);
    } catch (error) {
        console.error("Error fetching questions:", error);
        res.status(500).json({ message: "Error fetching questions" });
    }
});



router.post('/addStudents', async (req, res) => {
    try {
        const { name, email, sectionId } = req.body;
        console.log(req.body)
        const newStudent = new studentAccessModel({ name, email, sectionId });
        await newStudent.save();

        res.status(201).json({ message: 'Student added successfully', student: newStudent });
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: 'Failed to add student', details: error.message });
    }
});


router.put('/students/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { name, email, sectionId } = req.body;

        const updatedStudent = await studentAccessModel.findByIdAndUpdate(
            id,
            { name, email, sectionId },
            { new: true, runValidators: true }
        );

        if (!updatedStudent) {
            return res.status(404).json({ error: 'Student not found' });
        }

        res.status(200).json({ message: 'Student updated successfully', student: updatedStudent });
    } catch (error) {
        res.status(500).json({ error: 'Failed to update student', details: error.message });
    }
});


router.delete('/students/:id', async (req, res) => {
    try {
        const { id } = req.params;
        console.log(id)
        const deletedStudent = await studentAccessModel.findByIdAndDelete({_id: id});

        if (!deletedStudent) {
            return res.status(404).json({ error: 'Student not found' });
        }

        res.status(200).json({ message: 'Student deleted successfully', student: deletedStudent });
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: 'Failed to delete student', details: error.message });
    }
});


router.get('/students', async (req, res) => {
    try {
        const students = await studentAccessModel.find();
        res.status(200).json(students);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Route to generate a unique access code for all students
router.get('/generate-access-code', async (req, res) => {
    try {
        const students = await studentAccessModel.find();
        
        // Loop through each student to generate access codes and send emails
        for (const student of students) {
            const hasAccessCode = student.data.some(d => d.accessCode);

            if (!hasAccessCode) {
                const accessCode = student.generateAccessCode();
                student.data.push({ accessCode });
                await student.save();

                // Send access code email
                await emails.sendAccessCode(student.email, accessCode);
            }
        }

        res.status(200).json({ message: 'Access codes generated and sent successfully to students without one.' });
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: 'Failed to generate access codes', details: error.message });
    }
});


// Route to check access code and update attemptedDate
router.post('/check-access-code', async (req, res) => {
    try {
        console.log("Check access Request -> ", req.body)
        const { accessCode } = req.body;

        const student = await studentAccessModel.findOne({ 'data.accessCode': accessCode });
        
        if (!student) {
            return res.status(404).json({ error: 'Invalid access code' });
        }

        const dataIndex = student.data.findIndex(d => d.accessCode === accessCode);

        if (dataIndex !== -1) {
            const studentData = student.data[dataIndex];

            // Check if attemptedDate is already set
            if (studentData.attemptedDate) {
                return res.status(403).json({ error: 'Access code has already been used' });
            }

            // If attemptedDate is not set, update it and allow access
            studentData.attemptedDate = new Date();
            await student.save();

            res.status(200).json({ message: 'Access code verified and attempted date updated' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Failed to verify access code', details: error.message });
    }
});


// Route to add or update level1Score
router.put('/update-level1score', async (req, res) => {
    try {
        const { accessCode, level1Score } = req.body;

        const student = await studentAccessModel.findOne({ 'data.accessCode': accessCode });
        
        if (!student) {
            return res.status(404).json({ error: 'Invalid access code' });
        }

        const dataIndex = student.data.findIndex(d => d.accessCode === accessCode);
        if (dataIndex !== -1) {
            student.data[dataIndex].level1Score = level1Score;
            await student.save();
        }

        res.status(200).json({ message: 'Level 1 score updated successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Failed to update level 1 score', details: error.message });
    }
});


module.exports = router