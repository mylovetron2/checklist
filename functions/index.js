/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
//const fetch = require("node-fetch");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.fetchCheckList = onRequest(async (request, response) => {

    try {
        const apiUrl = "http://diavatly.com/checklist/api/danhmuc_checklist_api.php"; // Replace with the actual API URL
        const headers = {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": true,
            "Access-Control-Allow-Methods": "GET, POST",
            "Access-Control-Allow-Headers": "X-Requested-With"
        };

        const apiResponse = await fetch(apiUrl, { headers });
        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
        response.status(200).send(data);
    } catch (error) {
        logger.error("Error fetching checklist:", error);
        response.status(500).send({error: "Failed to fetch checklist"});
    }
});

exports.fetchLoaiMay = onRequest(async (request, response) => {

    try {
        const apiUrl = "http://diavatly.com/checklist/api/danhmuc_loaimay_api.php"; // Replace with the actual API URL
        const headers = {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": true,
            "Access-Control-Allow-Methods": "GET, POST",
            "Access-Control-Allow-Headers": "X-Requested-With"
        };

        const apiResponse = await fetch(apiUrl, { headers });
        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
        response.status(200).send(data);
    } catch (error) {
        logger.error("Error fetch LoaiMay:", error);
        response.status(500).send({error: "Failed to fetch LoaiMay"});
    }
});

exports.fetchDanhMucMay = onRequest(async (request, response) => {

    try {
        // const { idLoaiMay } = (request.query); // Use query parameters for GET request
        // if(request.method === 'GET') {
        //     response.status(200).send({ message: "GET request received", data: request.query , body: request.body ,"idLoaiMay" :idLoaiMay });
        // }
        // else {
        //     response.status(405).send({ error: "Method not allowed" });
        // }
        // if (!idLoaiMay) {
        //     response.status(400).send({ error: "Missing required parameter: idLoaiMay" });
        //     return;
        // }
        //idLoaiMay = request.query.idLoaiMay;
        //idLoaiMay="7";
        idLoaiMay = request.query.id_loai_may; // Default to "7" if not provided
        const apiUrl = `http://diavatly.com/checklist/api/danhmuc_may_api.php?id_loai_may=${idLoaiMay}`; // Append parameter to URL
        const headers = {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": true,
            "Access-Control-Allow-Methods": "GET, POST",
            "Access-Control-Allow-Headers": "X-Requested-With"
        };

        const apiResponse = await fetch(apiUrl);
        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
        response.status(200).send(data);
    } catch (error) {
        logger.error("Error fetching danh_muc_may:", error);
        response.status(500).send({error: "Failed to fetch danh_muc_may"});
    }
});


exports.fetchViewOnShore = onRequest(async (request, response) => {
    try {
        const apiUrl = "http://diavatly.com/checklist/api/danhmuc_may_onshore_api.php";
        const headers = {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": true,
            "Access-Control-Allow-Methods": "GET, POST",
            "Access-Control-Allow-Headers": "X-Requested-With"
        };

        const apiResponse = await fetch(apiUrl, { headers });
        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
        response.status(200).send(data);
    } catch (error) {
        logger.error("Error fetching view onshore:", error);
        response.status(500).send({ error: "Failed to fetch view onshore" });
    }
});


exports.getFetchDetailCheckListById = onRequest(async (request, response) => {
    try {
        const { id_danhmuc_checklist } = request.query; // Use query parameters for GET request

        if (!id_danhmuc_checklist) {
            response.status(400).send({ error: "Missing required parameter: id_danhmuc_checklist" });
            return;
        }

        const apiUrl = `http://diavatly.com/checklist/api/detail_checklist_api.php?id_danhmuc_checklist=${id_danhmuc_checklist}`; // Append parameter to URL
        const headers = {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": true,
            "Access-Control-Allow-Methods": "GET, POST",
            "Access-Control-Allow-Headers": "X-Requested-With"
        };

        const apiResponse = await fetch(apiUrl, {headers});

        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET,POST");
        response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
        response.status(200).send(data);
    } 
    catch (error) {
        logger.error("Error fetching detail checklist by ID:", error);
        response.status(500).send({ error: "Failed to fetch detail checklist by ID" });
    }
});

exports.insertCheckListApi = onRequest(async (request, response) => {
    try {
        
        const headers = {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": true,
            "Access-Control-Allow-Methods": "GET, POST",
            "Access-Control-Allow-Headers": "X-Requested-With"
        };

        //logger.info("Request body:", request.body); // Log the request body for debugging
        //const apiResponse = await fetch(apiUrl, { method: 'GET', headers, body: JSON.stringify(request.body) });

        const { date,well,doghouse } = request.query;
        const apiUrl = `http://diavatly.com/checklist/api/checklist_add.php?date=${(date)}&well=${(well)}&doghouse=${(doghouse)}`;
        const apiResponse = await fetch(apiUrl);
        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
        response.status(200).send(data);
    } catch (error) {
        logger.error("Error inserting checklist:", error);
        response.status(500).send({ error: "Failed to insert checklist" });
    }
});

exports.insertCheckListPostApi = onRequest(async (request, response) => {
    try {   
      
        //const postData={well:"test",doghouse:"test",date:"2023-10-10"};
        const postData = request.body; // Use the request body directly
        const { date,well,doghouse } = request.body;
        const apiUrl = `http://diavatly.com/checklist/api/checklist_add.php`;
        const apiResponse = await fetch(apiUrl, {
            method: 'POST',
            body:JSON.stringify(postData),
            headers: {"Content-Type": "application/json" }
                      
        });
        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
        //response.status(200).send(JSON.stringify({date,well,doghouse}));
        response.status(200).send(data);
    } catch (error) {
        logger.error("Error inserting checklist:", error);
        response.status(500).send({ error: "Failed to insert checklist" });
    }
});

exports.testPost = onRequest(async (request, response) => {
    console.log("Request body:", request.body); // Log the request body for debugging
    console.log("Request query:", request.query); // Log the request query for debugging
    if(request.method === 'POST') {
        response.status(200).send({ message: "POST request received", data: request.query , body: request.body });
    }
    else {
        response.status(405).send({ error: "Method not allowed" });
    }
});


exports.insertDetailCheckList = onRequest(async (request, response) => {
    try {
        const postData = request.body; // Use the request body directly
        const apiUrl = `http://diavatly.com/checklist/api/temp_api.php`;

        const apiResponse = await fetch(apiUrl, {
            method: 'POST',
            body: JSON.stringify(postData),
            headers: { "Content-Type": "application/json" }
        });

        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
        response.status(200).send(data);
    } catch (error) {
        logger.error("Error inserting detail checklist:", error);
        response.status(500).send({ error: "Failed to insert detail checklist" });
    }
});

exports.deleteChecklist = onRequest(async (request, response) => {
    try {
        // if (request.method !== 'POST') {
        //     response.status(405).send({ error: "Method not allowed" });
        //     return;
        // }
        const { checklist_id } = request.body;
        // if (!checklist_id) {
        //     response.status(400).send({ error: "Missing required parameter: checklist_id" });
        //     return;
        // }

        const apiUrl = `http://diavatly.com/checklist/api/checklist_delete.php`;
        const apiResponse = await fetch(apiUrl, {
            method: 'POST',
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ checklist_id })
        });

        if (!apiResponse.ok) {
            throw new Error(`API request failed with status ${apiResponse.status}`);
        }

        const data = await apiResponse.json();
        response.setHeader("Content-Type", "application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", true);
        response.setHeader("Access-Control-Allow-Methods", "GET, POST");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, X-Requested-With, Accept, Origin");
        response.status(200).send(data);
    } catch (error) {
        logger.error("Error deleting checklist:", error);
        response.status(500).send({ error: "Failed to delete checklist" });
    }
});





// exports.insertCheckListApi = onRequest(async (request, response) => {
//     try {
        
//         const headers = {
//             "Content-Type": "application/json",
//             "Access-Control-Allow-Origin": "*",
//             "Access-Control-Allow-Credentials": true,
//             "Access-Control-Allow-Methods": "GET, POST",
//             "Access-Control-Allow-Headers": "X-Requested-With"
//         };

//         //logger.info("Request body:", request.body); // Log the request body for debugging
//         //const apiResponse = await fetch(apiUrl, { method: 'GET', headers, body: JSON.stringify(request.body) });

//         const { date,well,doghouse } = request.query;
//         const apiUrl = `http://diavatly.com/checklist/api/checklist_add.php?date=${(date)}&well=${(well)}&doghouse=${(doghouse)}`;
//         const apiResponse = await fetch(apiUrl);
//         if (!apiResponse.ok) {
//             throw new Error(`API request failed with status ${apiResponse.status}`);
//         }

//         const data = await apiResponse.json();
//         response.setHeader("Content-Type", "application/json");
//         response.setHeader("Access-Control-Allow-Origin", "*");
//         response.setHeader("Access-Control-Allow-Credentials", true);
//         response.setHeader("Access-Control-Allow-Methods", "GET, POST");
//         response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
//         response.status(200).send(data);
//     } catch (error) {
//         logger.error("Error inserting checklist:", error);
//         response.status(500).send({ error: "Failed to insert checklist" });
//     }
// });