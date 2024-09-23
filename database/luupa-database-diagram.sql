CREATE TABLE "Cities" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "state" varchar,
  "country" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Users" (
  "id" int PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "email" varchar UNIQUE,
  "phone_number" varchar,
  "gender" varchar,
  "nationality" varchar,
  "city_id" int,
  "zip_code" varchar,
  "date_of_birth" date,
  "has_drivers_license" boolean,
  "vehicle_type" enum,
  "created_at" timestamp,
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "UserProfiles" (
  "id" int PRIMARY KEY,
  "user_id" int,
  "current_job_title" varchar,
  "preferred_job_type" varchar,
  "preferred_job_availability" json,
  "willing_to_travel" boolean,
  "years_of_experience" int,
  "bio" text,
  "desired_salary_range_min" float,
  "desired_salary_range_max" float,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Education" (
  "id" int PRIMARY KEY,
  "user_id" int,
  "degree" varchar,
  "field_of_study" varchar,
  "institution_name" varchar,
  "start_date" date,
  "end_date" date,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "WorkExperience" (
  "id" int PRIMARY KEY,
  "user_id" int,
  "company_name" varchar,
  "job_title" varchar,
  "description" text,
  "start_date" date,
  "end_date" date,
  "key_responsibilities" text,
  "equipment_used" text,
  "is_currently_employed" boolean,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Skills" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "category" enum,
  "subcategory" varchar,
  "description" text,
  "industry" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "UserSkills" (
  "id" int PRIMARY KEY,
  "user_id" int,
  "skill_id" int,
  "proficiency_level" enum,
  "years_of_experience" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Companies" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "city_id" int,
  "zip_code" varchar,
  "industry" varchar,
  "description" text,
  "created_at" timestamp,
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "Recruiters" (
  "id" int PRIMARY KEY,
  "company_id" int,
  "first_name" varchar,
  "last_name" varchar,
  "email" varchar,
  "phone_number" varchar,
  "created_at" timestamp,
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "Jobs" (
  "id" int PRIMARY KEY,
  "company_id" int,
  "recruiter_id" int,
  "city_id" int,
  "title" varchar,
  "description" text,
  "job_type" enum,
  "salary_min" float,
  "salary_max" float,
  "other_benefits" text,
  "shifts" json,
  "required_certifications" text,
  "physical_requirements" text,
  "total_open_roles" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "JobSkills" (
  "id" int PRIMARY KEY,
  "job_id" int,
  "skill_id" int,
  "importance_level" enum,
  "years_of_experience" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "JobApplications" (
  "id" int PRIMARY KEY,
  "job_id" int,
  "user_id" int,
  "application_status" enum,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Evaluations" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "description" text,
  "difficulty_level" enum,
  "evaluation_type" enum,
  "passing_score" float,
  "version" int,
  "time_limit" int,
  "is_active" boolean,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "EvaluationSkills" (
  "id" int PRIMARY KEY,
  "evaluation_id" int,
  "skill_id" int,
  "weight" float,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "Questions" (
  "id" int PRIMARY KEY,
  "evaluation_id" int,
  "question_text" text,
  "question_type" enum,
  "difficulty_level" enum,
  "points" int,
  "order_number" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "QuestionSkills" (
  "id" int PRIMARY KEY,
  "question_id" int,
  "skill_id" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "QuestionOptions" (
  "id" int PRIMARY KEY,
  "question_id" int,
  "option_text" text,
  "is_correct" boolean,
  "order_number" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "UserEvaluationAttempts" (
  "id" int PRIMARY KEY,
  "user_id" int,
  "evaluation_id" int,
  "start_time" timestamp,
  "end_time" timestamp,
  "total_score" float,
  "passed" boolean,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "UserResponses" (
  "id" int PRIMARY KEY,
  "attempt_id" int,
  "question_id" int,
  "selected_option_id" int,
  "text_response" text,
  "file_url" varchar,
  "is_correct" boolean,
  "score" float,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "UserFiles" (
  "id" int PRIMARY KEY,
  "user_id" int,
  "response_id" int,
  "file_name" varchar,
  "file_path" varchar,
  "file_type" varchar,
  "file_size" int,
  "uploaded_at" timestamp
);

CREATE TABLE "ReviewQueue" (
  "id" int PRIMARY KEY,
  "response_id" int,
  "reviewer_id" int,
  "status" enum,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "ReviewResults" (
  "id" int PRIMARY KEY,
  "review_id" int,
  "score" float,
  "feedback" text,
  "reviewed_at" timestamp,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE UNIQUE INDEX ON "JobSkills" ("job_id", "skill_id");

CREATE UNIQUE INDEX ON "EvaluationSkills" ("evaluation_id", "skill_id");

CREATE UNIQUE INDEX ON "QuestionSkills" ("question_id", "skill_id");

ALTER TABLE "Users" ADD FOREIGN KEY ("city_id") REFERENCES "Cities" ("id");

ALTER TABLE "UserProfiles" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "Education" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "WorkExperience" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "UserSkills" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "UserSkills" ADD FOREIGN KEY ("skill_id") REFERENCES "Skills" ("id");

ALTER TABLE "Companies" ADD FOREIGN KEY ("city_id") REFERENCES "Cities" ("id");

ALTER TABLE "Recruiters" ADD FOREIGN KEY ("company_id") REFERENCES "Companies" ("id");

ALTER TABLE "Jobs" ADD FOREIGN KEY ("company_id") REFERENCES "Companies" ("id");

ALTER TABLE "Jobs" ADD FOREIGN KEY ("recruiter_id") REFERENCES "Recruiters" ("id");

ALTER TABLE "Jobs" ADD FOREIGN KEY ("city_id") REFERENCES "Cities" ("id");

ALTER TABLE "JobSkills" ADD FOREIGN KEY ("job_id") REFERENCES "Jobs" ("id");

ALTER TABLE "JobSkills" ADD FOREIGN KEY ("skill_id") REFERENCES "Skills" ("id");

ALTER TABLE "JobApplications" ADD FOREIGN KEY ("job_id") REFERENCES "Jobs" ("id");

ALTER TABLE "JobApplications" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "EvaluationSkills" ADD FOREIGN KEY ("evaluation_id") REFERENCES "Evaluations" ("id");

ALTER TABLE "EvaluationSkills" ADD FOREIGN KEY ("skill_id") REFERENCES "Skills" ("id");

ALTER TABLE "Questions" ADD FOREIGN KEY ("evaluation_id") REFERENCES "Evaluations" ("id");

ALTER TABLE "QuestionSkills" ADD FOREIGN KEY ("question_id") REFERENCES "Questions" ("id");

ALTER TABLE "QuestionSkills" ADD FOREIGN KEY ("skill_id") REFERENCES "Skills" ("id");

ALTER TABLE "QuestionOptions" ADD FOREIGN KEY ("question_id") REFERENCES "Questions" ("id");

ALTER TABLE "UserEvaluationAttempts" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "UserEvaluationAttempts" ADD FOREIGN KEY ("evaluation_id") REFERENCES "Evaluations" ("id");

ALTER TABLE "UserResponses" ADD FOREIGN KEY ("attempt_id") REFERENCES "UserEvaluationAttempts" ("id");

ALTER TABLE "UserResponses" ADD FOREIGN KEY ("question_id") REFERENCES "Questions" ("id");

ALTER TABLE "UserResponses" ADD FOREIGN KEY ("selected_option_id") REFERENCES "QuestionOptions" ("id");

ALTER TABLE "UserFiles" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id");

ALTER TABLE "UserFiles" ADD FOREIGN KEY ("response_id") REFERENCES "UserResponses" ("id");

ALTER TABLE "ReviewQueue" ADD FOREIGN KEY ("response_id") REFERENCES "UserResponses" ("id");

ALTER TABLE "ReviewQueue" ADD FOREIGN KEY ("reviewer_id") REFERENCES "Users" ("id");

ALTER TABLE "ReviewResults" ADD FOREIGN KEY ("review_id") REFERENCES "ReviewQueue" ("id");
