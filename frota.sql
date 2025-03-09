-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 09/03/2025 às 23:41
-- Versão do servidor: 8.0.41-0ubuntu0.24.04.1
-- Versão do PHP: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `frota`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `acl_updates`
--

CREATE TABLE `acl_updates` (
  `id` bigint UNSIGNED NOT NULL,
  `updates` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `acl_updates`
--

INSERT INTO `acl_updates` (`id`, `updates`, `updated_at`) VALUES
(1, '{\"user_id\":[0,1,1,1,1],\"roles\":[{\"Super Admin\":1},{\"Super Admin\":1,\"Motorista Administrar\":9},{\"Super Admin\":1,\"Motorista Administrar\":9,\"Garagem Administrar\":14},{\"Super Admin\":1,\"Garagem Administrar\":14},{\"Super Admin\":1}],\"updated_at\":[\"2025-02-22T16:54:48.465713Z\",\"2025-02-22T17:08:07.134476Z\",\"2025-02-22T17:09:00.718745Z\",\"2025-02-22T17:26:34.657456Z\"]}', '2025-02-22 17:26:34'),
(2, '{\"user_id\":[0,1],\"roles\":[{\"Motorista\":8},{\"Motorista\":8,\"Combustivel Administrar\":15}],\"updated_at\":\"2025-01-16T22:54:52.481769Z\"}', '2025-01-16 22:54:52'),
(3, '{\"user_id\":[0,1],\"roles\":[[],{\"Solicitante\":16}],\"updated_at\":\"2025-01-19T11:50:29.103162Z\"}', '2025-01-19 11:50:29'),
(5, '{\"user_id\":[0,1],\"roles\":[[],{\"Motorista\":8}],\"updated_at\":\"2025-02-09T21:05:40.759744Z\"}', '2025-02-09 21:05:40'),
(6, '{\"user_id\":[0,1,1,1,1,1],\"roles\":[[],{\"Liberador\":17},{\"Tarefa Administrar\":12,\"Liberador\":17},{\"Agenda Administrar\":11,\"Tarefa Administrar\":12,\"Liberador\":17},{\"Tarefa Administrar\":12,\"Liberador\":17},{\"Tarefa Administrar\":12,\"Solicitante\":16,\"Liberador\":17}],\"updated_at\":[\"2025-02-22T16:46:42.342565Z\",\"2025-02-22T17:27:57.715426Z\",\"2025-02-22T17:28:21.219891Z\",\"2025-02-22T17:28:30.072565Z\",\"2025-02-22T17:33:15.781415Z\"]}', '2025-02-22 17:33:15');

-- --------------------------------------------------------

--
-- Estrutura para tabela `attaches`
--

CREATE TABLE `attaches` (
  `id` bigint UNSIGNED NOT NULL,
  `maintenance_id` bigint UNSIGNED NOT NULL,
  `type` int NOT NULL,
  `filename` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `branches`
--

CREATE TABLE `branches` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cnpj` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phones` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cep` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(510) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `branches`
--

INSERT INTO `branches` (`id`, `name`, `cnpj`, `email`, `phones`, `cep`, `notes`, `address`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Não Cadastrada', NULL, NULL, NULL, NULL, 'Unidade pra locais não cadastrados.', 'Não Cadastrada', NULL, '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(2, 'SEMSA', NULL, NULL, NULL, NULL, NULL, 'Prédio SEMSA', NULL, '2025-01-16 22:55:29', '2025-01-16 22:55:29'),
(3, 'Almoxarifado', NULL, NULL, NULL, NULL, NULL, 'Rodovia Darly Santos, atrás do Posto Rede Marcela', NULL, '2025-01-16 22:56:14', '2025-01-16 22:56:14'),
(4, 'US Araçás', NULL, NULL, NULL, NULL, NULL, 'Praça de Araçás', NULL, '2025-01-16 22:56:44', '2025-01-16 22:56:44'),
(5, 'Garagem Vila Nova', NULL, NULL, NULL, NULL, NULL, 'Anexo a US Vila Nova', NULL, '2025-01-16 22:58:04', '2025-01-16 22:58:04'),
(6, 'Central', NULL, NULL, NULL, NULL, NULL, 'Garagem Central', NULL, '2025-02-06 16:01:30', '2025-02-06 16:01:30'),
(7, 'US Paul', NULL, NULL, NULL, NULL, NULL, 'Praça de Paul', NULL, '2025-02-14 00:05:19', '2025-02-14 00:05:19');

-- --------------------------------------------------------

--
-- Estrutura para tabela `branch_updates`
--

CREATE TABLE `branch_updates` (
  `id` bigint UNSIGNED NOT NULL,
  `updates` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cars`
--

CREATE TABLE `cars` (
  `id` bigint UNSIGNED NOT NULL,
  `marca` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `modelo` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `placa` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `patrimonio` tinyint(1) NOT NULL,
  `tombo` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `garagem_id` bigint UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `cars`
--

INSERT INTO `cars` (`id`, `marca`, `modelo`, `placa`, `patrimonio`, `tombo`, `garagem_id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'VW', 'Polo', 'ABC0D12', 0, NULL, NULL, NULL, '2025-01-16 23:00:12', '2025-02-23 20:51:04'),
(2, 'Fiat', 'Novo Uno', 'EFG3H45', 1, '123654', NULL, NULL, '2025-01-16 23:00:52', '2025-01-16 23:00:52'),
(3, 'Ford', 'Ka', 'IJK7L89', 1, '98745', 3, NULL, '2025-01-16 23:03:01', '2025-02-23 21:42:14');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cars_log`
--

CREATE TABLE `cars_log` (
  `id` bigint UNSIGNED NOT NULL,
  `route` bigint UNSIGNED NOT NULL,
  `car` bigint UNSIGNED NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `km` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `cars_log`
--

INSERT INTO `cars_log` (`id`, `route`, `car`, `type`, `km`) VALUES
(1, 91, 2, 'start', 120),
(2, 91, 2, 'end', 123),
(3, 92, 2, 'start', 129),
(4, 92, 2, 'end', 135),
(5, 102, 1, 'start', 100),
(6, 102, 1, 'end', 103),
(7, 103, 3, 'start', 103),
(8, 103, 3, 'end', 106),
(9, 104, 3, 'start', 106),
(10, 104, 3, 'end', 109),
(11, 105, 3, 'start', 1523),
(12, 105, 3, 'end', 1529),
(14, 106, 3, 'start', 1529),
(15, 106, 3, 'end', 1530),
(16, 107, 1, 'start', 1),
(17, 107, 1, 'end', 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `clients`
--

CREATE TABLE `clients` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cpf` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cep` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(510) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phones` varchar(105) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `branch_id` bigint UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `client_updates`
--

CREATE TABLE `client_updates` (
  `id` bigint UNSIGNED NOT NULL,
  `updates` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `drivers`
--

CREATE TABLE `drivers` (
  `id` bigint UNSIGNED NOT NULL,
  `garagem_id` bigint UNSIGNED DEFAULT NULL,
  `carro_favorito` bigint UNSIGNED DEFAULT NULL,
  `proprio` tinyint(1) NOT NULL DEFAULT '0',
  `matricula` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cnh` tinyint(1) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `drivers`
--

INSERT INTO `drivers` (`id`, `garagem_id`, `carro_favorito`, `proprio`, `matricula`, `cnh`, `deleted_at`, `created_at`, `updated_at`) VALUES
(2, 2, 2, 0, NULL, 1, NULL, '2025-01-16 22:54:33', '2025-01-16 23:03:47'),
(4, 5, 1, 0, NULL, 0, NULL, '2025-01-26 21:04:41', '2025-03-04 23:45:50'),
(5, 2, 2, 0, NULL, 1, NULL, '2025-01-16 22:54:33', '2025-02-23 23:21:44'),
(7, 5, 3, 0, NULL, 0, NULL, '2025-02-23 23:21:31', '2025-02-23 23:21:31');

-- --------------------------------------------------------

--
-- Estrutura para tabela `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fuels`
--

CREATE TABLE `fuels` (
  `id` bigint UNSIGNED NOT NULL,
  `car` bigint UNSIGNED NOT NULL,
  `driver` bigint UNSIGNED NOT NULL,
  `km` int NOT NULL,
  `quantidade` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `local` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observacao` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `arquivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `fuels`
--

INSERT INTO `fuels` (`id`, `car`, `driver`, `km`, `quantidade`, `valor`, `local`, `observacao`, `arquivo`, `hora`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 2, 2, 1000, '10', '45.48', NULL, NULL, NULL, '2025-01-16 18:35:00', NULL, '2025-01-17 00:17:18', '2025-01-17 00:17:18'),
(4, 2, 2, 1150, '10', '56.50', 'Posto Sete', 'Logo ali!', NULL, '2025-01-17 00:52:43', NULL, '2025-01-17 00:52:43', '2025-01-17 00:52:43'),
(5, 2, 2, 1152, '1', '5,48', NULL, NULL, NULL, '2025-01-17 00:54:07', NULL, '2025-01-17 00:54:07', '2025-01-17 00:54:07'),
(6, 2, 5, 1260, '10', '58.60', 'Posto Marcela Almoxarifado', 'Somente reserva', NULL, '2025-02-15 18:50:00', NULL, '2025-02-15 19:07:05', '2025-02-15 19:07:05'),
(7, 2, 5, 1159, '10', '58.35', NULL, NULL, NULL, '2025-02-10 11:00:00', NULL, '2025-02-15 21:05:14', '2025-02-15 21:05:14'),
(8, 2, 2, 1200, '10', '45.48', NULL, NULL, NULL, '2025-01-16 18:36:00', NULL, '2025-01-17 00:17:18', '2025-01-17 00:17:18'),
(9, 2, 2, 1201, '10', '56.50', 'Posto Sete', 'Logo ali!', NULL, '2025-01-17 00:52:43', NULL, '2025-01-17 00:52:43', '2025-01-17 00:52:43'),
(10, 2, 2, 1202, '1', '5,48', NULL, NULL, NULL, '2025-01-17 00:59:07', NULL, '2025-01-17 00:54:07', '2025-01-17 00:54:07'),
(11, 2, 5, 1203, '10', '58.60', 'Posto Marcela Almoxarifado', 'Somente reserva', NULL, '2025-02-15 18:55:00', NULL, '2025-02-15 19:07:05', '2025-02-15 19:07:05'),
(12, 2, 5, 1205, '10', '58.35', NULL, NULL, NULL, '2025-02-10 11:30:00', NULL, '2025-02-15 21:05:14', '2025-02-15 21:05:14'),
(13, 2, 2, 1000, '10', '45.48', NULL, NULL, NULL, '2025-01-16 18:35:00', NULL, '2025-01-17 00:17:18', '2025-01-17 00:17:18'),
(14, 2, 2, 1150, '10', '56.50', 'Posto Sete', 'Logo ali!', NULL, '2025-01-17 00:52:43', NULL, '2025-01-17 00:52:43', '2025-01-17 00:52:43'),
(15, 2, 2, 1152, '1', '5,48', NULL, NULL, NULL, '2025-01-17 00:54:07', NULL, '2025-01-17 00:54:07', '2025-01-17 00:54:07'),
(16, 2, 5, 1260, '10', '58.60', 'Posto Marcela Almoxarifado', 'Somente reserva', NULL, '2025-02-15 18:50:00', NULL, '2025-02-15 19:07:05', '2025-02-15 19:07:05'),
(17, 2, 5, 1159, '10', '58.35', NULL, NULL, NULL, '2025-02-10 11:00:00', NULL, '2025-02-15 21:05:14', '2025-02-15 21:05:14'),
(18, 2, 2, 1200, '10', '45.48', NULL, NULL, NULL, '2025-01-16 18:36:00', NULL, '2025-01-17 00:17:18', '2025-01-17 00:17:18'),
(19, 2, 2, 1201, '10', '56.50', 'Posto Sete', 'Logo ali!', NULL, '2025-01-17 00:52:43', NULL, '2025-01-17 00:52:43', '2025-01-17 00:52:43'),
(20, 2, 2, 1202, '1', '5,48', NULL, NULL, NULL, '2025-01-17 00:59:07', NULL, '2025-01-17 00:54:07', '2025-01-17 00:54:07'),
(21, 2, 5, 1203, '10', '58.60', 'Posto Marcela Almoxarifado', 'Somente reserva', NULL, '2025-02-15 18:55:00', NULL, '2025-02-15 19:07:05', '2025-02-15 19:07:05'),
(22, 2, 5, 1205, '10', '58.35', NULL, NULL, NULL, '2025-02-10 11:30:00', NULL, '2025-02-15 21:05:14', '2025-02-15 21:05:14'),
(23, 1, 5, 100, '10', '58.60', 'Posto Sete', 'Teste abastecimento.', NULL, '2025-02-23 21:01:00', NULL, '2025-02-23 21:01:56', '2025-02-23 21:01:56');

-- --------------------------------------------------------

--
-- Estrutura para tabela `garages`
--

CREATE TABLE `garages` (
  `id` bigint UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `garages`
--

INSERT INTO `garages` (`id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(2, NULL, '2025-01-16 22:57:41', '2025-02-22 17:12:53'),
(3, NULL, '2025-02-06 15:59:08', '2025-02-06 15:59:08'),
(5, NULL, '2025-01-16 22:58:11', '2025-01-16 22:58:11'),
(6, NULL, '2025-02-06 16:01:34', '2025-02-06 16:01:34');

-- --------------------------------------------------------

--
-- Estrutura para tabela `incidents`
--

CREATE TABLE `incidents` (
  `id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `justifications`
--

CREATE TABLE `justifications` (
  `route` bigint UNSIGNED NOT NULL,
  `user` bigint UNSIGNED NOT NULL,
  `justification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `maintenances`
--

CREATE TABLE `maintenances` (
  `id` bigint UNSIGNED NOT NULL,
  `car` bigint UNSIGNED NOT NULL,
  `km_arrival` int DEFAULT NULL,
  `km_departure` int DEFAULT NULL,
  `date_arrival` timestamp NULL DEFAULT NULL,
  `date_departure` timestamp NULL DEFAULT NULL,
  `type` int NOT NULL,
  `date` date NOT NULL,
  `time` time DEFAULT NULL,
  `place` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mechanic` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `replaces` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `obs` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `maintenances`
--

INSERT INTO `maintenances` (`id`, `car`, `km_arrival`, `km_departure`, `date_arrival`, `date_departure`, `type`, `date`, `time`, `place`, `mechanic`, `replaces`, `cost`, `obs`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, NULL, NULL, NULL, 1, '2025-03-12', '10:00:00', 'Casa do Silencioso', 'Jurandir', 'Pneus e Freios', 950.5, 'Inserção de teste', '2025-03-09 20:41:15', '2025-03-09 20:41:15'),
(2, 1, NULL, NULL, NULL, NULL, 2, '2025-03-14', '12:00:00', 'Casa do Silencioso', 'Lucrécio', 'Amortecedor', 950.5, 'Inserção de teste 2', '2025-03-09 21:06:53', '2025-03-09 21:06:53');

-- --------------------------------------------------------

--
-- Estrutura para tabela `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000001_create_cache_table', 1),
(2, '0001_01_01_000002_create_jobs_table', 1),
(3, '2014_09_29_100932_create_branches_table', 1),
(4, '2014_10_12_000000_create_users_table', 1),
(5, '2014_10_12_100000_create_password_resets_table', 1),
(6, '2022_10_20_000921_create_permission_tables', 1),
(7, '2022_11_29_100933_create_clients_table', 1),
(8, '2022_12_09_110718_create_settings_table', 1),
(9, '2022_12_10_110444_create_user_updates', 1),
(10, '2022_12_10_110445_create_client_updates', 1),
(11, '2022_12_10_110507_create_branch_updates', 1),
(12, '2022_12_10_110719_create_permission_updates', 1),
(13, '2022_12_10_110719_create_setting_updates', 1),
(14, '2022_12_10_110720_create_role_updates', 1),
(15, '2022_12_10_110721_create_acl_updates', 1),
(16, '2023_06_02_110700_create_garages_table', 1),
(17, '2023_06_02_110701_create_cars_table', 1),
(18, '2023_06_02_110702_create_drivers_table', 1),
(19, '2023_06_02_110703_create_timetables_table', 1),
(20, '2023_06_02_110704_create_schedules_table', 1),
(21, '2023_06_02_110705_create_tasks_table', 1),
(22, '2023_06_02_110706_create_routes_table', 1),
(23, '2023_06_02_111351_create_incidents_table', 1),
(24, '2023_06_02_111352_create_cars_log', 1),
(25, '2023_06_02_111353_create_real_branches_table', 1),
(26, '2023_06_02_111354_create_fuels_table', 1),
(27, '2024_11_07_123359_add_two_factor_columns_to_users_table', 1),
(28, '2024_11_07_123500_create_personal_access_tokens_table', 1),
(33, '2023_06_02_111355_create_requests_table', 2),
(34, '2023_06_02_110707_create_justifications_table', 3),
(35, '2025_03_05_150027_create_maintenance_table', 4),
(36, '2025_03_05_153048_create_attaches_table', 4);

-- --------------------------------------------------------

--
-- Estrutura para tabela `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(8, 'App\\Models\\User', 2),
(15, 'App\\Models\\User', 2),
(16, 'App\\Models\\User', 3),
(8, 'App\\Models\\User', 4),
(8, 'App\\Models\\User', 5),
(12, 'App\\Models\\User', 6),
(16, 'App\\Models\\User', 6),
(17, 'App\\Models\\User', 6),
(8, 'App\\Models\\User', 7);

-- --------------------------------------------------------

--
-- Estrutura para tabela `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'Usuario Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(2, 'Admin Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(3, 'Cliente Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(4, 'Usuario Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(5, 'Admin Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(6, 'Cliente Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(7, 'Usuario Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(8, 'Admin Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(9, 'Cliente Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(10, 'Usuario Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(11, 'Admin Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(12, 'Cliente Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(13, 'ACL Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(14, 'ACL Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(15, 'ACL Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(16, 'ACL Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(17, 'Relatorio Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(18, 'Dados Lancar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(19, 'Unidade Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(20, 'Unidade Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(21, 'Unidade Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(22, 'Unidade Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(23, 'Motorista Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(24, 'Motorista Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(25, 'Motorista Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(26, 'Motorista Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(27, 'Carro Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(28, 'Carro Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(29, 'Carro Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(30, 'Carro Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(31, 'Agenda Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(32, 'Agenda Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(33, 'Agenda Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(34, 'Agenda Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(35, 'Tarefa Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(36, 'Tarefa Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(37, 'Tarefa Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(38, 'Tarefa Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(39, 'Ocorrencia Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 23:16:23'),
(40, 'Ocorrencia Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 23:16:33'),
(41, 'Ocorrencia Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 23:16:02'),
(42, 'Ocorrencia Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 23:16:28'),
(43, 'Garagem Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(44, 'Garagem Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(45, 'Garagem Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(46, 'Garagem Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(47, 'Combustivel Criar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(48, 'Combustivel Ver', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(49, 'Combustivel Apagar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(50, 'Combustivel Editar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(51, 'Solicitacao Criar', 'web', '2025-01-19 11:44:54', '2025-01-19 11:44:54'),
(52, 'Solicitacao Ver', 'web', '2025-01-19 11:45:40', '2025-01-19 11:45:40'),
(53, 'Solicitacao Apagar', 'web', '2025-01-19 11:46:01', '2025-01-19 11:46:01'),
(54, 'Solicitacao Editar', 'web', '2025-01-19 11:46:37', '2025-01-19 11:46:37'),
(55, 'Liberador', 'web', '2025-02-22 16:35:53', '2025-02-22 16:35:53'),
(56, 'Manutencao Criar', 'web', '2025-03-09 19:56:15', '2025-03-09 19:56:15'),
(57, 'Manutencao Ver', 'web', '2025-03-09 19:56:25', '2025-03-09 19:56:25'),
(58, 'Manutencao Editar', 'web', '2025-03-09 19:56:36', '2025-03-09 19:56:36'),
(59, 'Manutencao Apagar', 'web', '2025-03-09 19:56:41', '2025-03-09 19:56:41');

-- --------------------------------------------------------

--
-- Estrutura para tabela `permission_updates`
--

CREATE TABLE `permission_updates` (
  `id` bigint UNSIGNED NOT NULL,
  `updates` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `permission_updates`
--

INSERT INTO `permission_updates` (`id`, `updates`, `updated_at`) VALUES
(39, '{\"user_id\":[0,1],\"name\":[\"Ocorr\\u00eancia Criar\",\"Ocorrencia Criar\"],\"guard_name\":[\"web\",\"web\"],\"updated_at\":[\"2025-01-16T22:38:12.000000Z\",\"2025-01-16T23:16:23.000000Z\"]}', '2025-01-16 23:16:23'),
(40, '{\"user_id\":[0,1],\"name\":[\"Ocorr\\u00eancia Ver\",\"Ocorrencia Ver\"],\"guard_name\":[\"web\",\"web\"],\"updated_at\":[\"2025-01-16T22:38:12.000000Z\",\"2025-01-16T23:16:33.000000Z\"]}', '2025-01-16 23:16:33'),
(41, '{\"user_id\":[0,1],\"name\":[\"Ocorr\\u00eancia Apagar\",\"Ocorrencia Apagar\"],\"guard_name\":[\"web\",\"web\"],\"updated_at\":[\"2025-01-16T22:38:12.000000Z\",\"2025-01-16T23:16:02.000000Z\"]}', '2025-01-16 23:16:02'),
(42, '{\"user_id\":[0,1],\"name\":[\"Ocorr\\u00eancia Editar\",\"Ocorrencia Editar\"],\"guard_name\":[\"web\",\"web\"],\"updated_at\":[\"2025-01-16T22:38:12.000000Z\",\"2025-01-16T23:16:28.000000Z\"]}', '2025-01-16 23:16:28');

-- --------------------------------------------------------

--
-- Estrutura para tabela `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `real_branches`
--

CREATE TABLE `real_branches` (
  `route` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `real_branches`
--

INSERT INTO `real_branches` (`route`, `name`) VALUES
(92, 'Pracinha Centro'),
(103, 'Abastecer');

-- --------------------------------------------------------

--
-- Estrutura para tabela `requests`
--

CREATE TABLE `requests` (
  `id` bigint UNSIGNED NOT NULL,
  `driver` bigint UNSIGNED DEFAULT NULL,
  `user` bigint UNSIGNED NOT NULL,
  `mediator` bigint UNSIGNED DEFAULT NULL,
  `to` bigint UNSIGNED NOT NULL,
  `local` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vacancy` int DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `duration` time DEFAULT NULL,
  `passengers` varchar(510) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `requests`
--

INSERT INTO `requests` (`id`, `driver`, `user`, `mediator`, `to`, `local`, `vacancy`, `date`, `time`, `duration`, `passengers`, `status`) VALUES
(1, 2, 3, NULL, 1, 'Ali', NULL, '2025-01-20', '07:30:00', NULL, NULL, 0),
(2, NULL, 3, NULL, 2, NULL, NULL, '2025-01-20', '09:00:00', NULL, '[\"ACS Maria\",\"ASS Andrea\",\"PS Camila\"]', 0),
(3, 2, 3, NULL, 4, NULL, NULL, '2025-01-20', '15:30:00', NULL, '[\"ACS Maria\",\"ASS Andrea\"]', 0),
(4, NULL, 3, NULL, 2, NULL, NULL, '2025-01-21', '09:00:00', NULL, '[\"Gabinete\"]', 0),
(5, 2, 1, NULL, 1, 'Ali', NULL, '2025-01-27', '07:00:00', '00:10:00', '[\"Ele ali\"]', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(2, 'Admin', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(3, 'Viewer', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(4, 'ACL Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(5, 'Usuario Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(6, 'Cliente Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(7, 'Unidade Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(8, 'Motorista', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(9, 'Motorista Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(10, 'Carro Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(11, 'Agenda Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(12, 'Tarefa Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(13, 'Ocorrencia Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(14, 'Garagem Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(15, 'Combustivel Administrar', 'web', '2025-01-16 22:38:12', '2025-01-16 22:38:12'),
(16, 'Solicitante', 'web', '2025-01-19 11:48:47', '2025-01-19 11:48:47'),
(17, 'Liberador', 'web', '2025-02-22 16:40:19', '2025-02-22 16:40:19'),
(18, 'Manutencao Administrar', 'web', '2025-03-09 19:57:14', '2025-03-09 19:57:14');

-- --------------------------------------------------------

--
-- Estrutura para tabela `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(3, 2),
(6, 2),
(10, 2),
(12, 2),
(17, 2),
(18, 2),
(19, 2),
(12, 3),
(19, 3),
(13, 4),
(14, 4),
(15, 4),
(16, 4),
(1, 5),
(4, 5),
(10, 5),
(3, 6),
(6, 6),
(12, 6),
(19, 7),
(20, 7),
(21, 7),
(22, 7),
(17, 8),
(39, 8),
(40, 8),
(41, 8),
(42, 8),
(23, 9),
(24, 9),
(25, 9),
(26, 9),
(27, 10),
(28, 10),
(29, 10),
(30, 10),
(31, 11),
(32, 11),
(33, 11),
(34, 11),
(35, 12),
(36, 12),
(37, 12),
(38, 12),
(39, 13),
(40, 13),
(41, 13),
(42, 13),
(43, 14),
(44, 14),
(45, 14),
(46, 14),
(47, 15),
(48, 15),
(49, 15),
(50, 15),
(32, 16),
(36, 16),
(51, 16),
(52, 16),
(53, 16),
(54, 16),
(19, 17),
(24, 17),
(28, 17),
(32, 17),
(36, 17),
(44, 17),
(55, 17),
(56, 18),
(57, 18),
(58, 18),
(59, 18);

-- --------------------------------------------------------

--
-- Estrutura para tabela `role_updates`
--

CREATE TABLE `role_updates` (
  `id` bigint UNSIGNED NOT NULL,
  `updates` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `role_updates`
--

INSERT INTO `role_updates` (`id`, `updates`, `updated_at`) VALUES
(8, '{\"user_id\":[0,1,1],\"name\":[\"Motorista\",\"Motorista\",\"Motorista\"],\"guard_name\":[\"web\",\"web\",\"web\"],\"updated_at\":[\"2025-01-16T22:38:12.000000Z\",\"2025-01-16T22:38:12.000000Z\",\"2025-01-16T22:38:12.000000Z\"],\"permissions\":[[17,21,35,36,37,38,39,40,41,42],[17,21,39,40,41,42],[17,39,40,41,42]]}', '2025-01-16 23:13:45'),
(16, '{\"user_id\":[0,1],\"name\":[\"Solicitante\",\"Solicitante\"],\"guard_name\":[\"web\",\"web\"],\"updated_at\":[\"2025-01-19T11:48:47.000000Z\",\"2025-01-19T11:48:47.000000Z\"],\"permissions\":[[51,52,53,54],[32,36,51,52,53,54]]}', '2025-01-19 11:50:58');

-- --------------------------------------------------------

--
-- Estrutura para tabela `routes`
--

CREATE TABLE `routes` (
  `id` bigint UNSIGNED NOT NULL,
  `task` bigint UNSIGNED NOT NULL,
  `user` bigint UNSIGNED NOT NULL,
  `mediator` bigint UNSIGNED DEFAULT NULL,
  `to` bigint UNSIGNED NOT NULL,
  `vacancy` int DEFAULT NULL,
  `passengers` varchar(510) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `obs_start` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `obs_end` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `duration` time DEFAULT NULL,
  `started_at` timestamp NULL DEFAULT NULL,
  `ended_at` timestamp NULL DEFAULT NULL,
  `obs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` int NOT NULL DEFAULT '0',
  `type` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `routes`
--

INSERT INTO `routes` (`id`, `task`, `user`, `mediator`, `to`, `vacancy`, `passengers`, `obs_start`, `obs_end`, `date`, `time`, `duration`, `started_at`, `ended_at`, `obs`, `status`, `type`) VALUES
(66, 14, 1, NULL, 2, NULL, '[{\"passenger\":\"Pass\",\"contact\":\"12345678\"}]', NULL, NULL, '2025-02-04', '13:15:00', '00:20:00', NULL, NULL, 'Teste após limpar tabelas', 0, 1),
(67, 16, 1, NULL, 3, NULL, '[{\"passenger\":\"Sem Motorista\",\"contact\":\"12345678\"}]', NULL, NULL, '2025-02-04', '13:30:00', '00:45:00', NULL, NULL, 'Teste após limpar tabelas', 1, 1),
(68, 15, 1, NULL, 4, NULL, '[{\"passenger\":\"asdffdas\",\"contact\":\"fasfasf@fasfa\"}]', NULL, NULL, '2025-02-04', '09:30:00', '00:15:00', NULL, NULL, 'Continuação dos testes!', 1, 1),
(69, 17, 1, NULL, 3, NULL, '[{\"passenger\":\"vzxcvzxvz\",\"contact\":\"zxvzxvzxcvzx\"}]', NULL, NULL, '2025-02-05', '10:00:00', '11:22:00', NULL, NULL, 'zxcvzx', 2, 1),
(70, 15, 1, NULL, 2, NULL, '[{\"passenger\":\"aasfasf\",\"contact\":\"fasdfasf\"}]', NULL, NULL, '2025-02-04', '06:00:00', '23:04:00', NULL, NULL, 'sadf', 0, 1),
(71, 15, 1, NULL, 2, NULL, '[{\"passenger\":\"asfasfas\",\"contact\":\"fasfasdfa\"}]', NULL, NULL, '2025-02-06', '06:15:00', '11:22:00', NULL, NULL, 'sadfasf', 2, 1),
(72, 18, 1, NULL, 2, NULL, '[{\"passenger\":\"f asdfasf a\",\"contact\":\"f asfasfa\"}]', NULL, NULL, '2025-02-07', '07:00:00', '00:11:00', NULL, NULL, 'fsda fasdf', 1, 1),
(73, 19, 1, NULL, 3, NULL, '[{\"passenger\":\"casdfasd\",\"contact\":\"fsdaf afd\"}]', NULL, NULL, '2025-02-07', '07:00:00', '00:01:00', NULL, NULL, 'Dara', 0, 0),
(74, 19, 1, NULL, 4, NULL, '[{\"passenger\":\"fasdfa\",\"contact\":\"fasdfasfa\"}]', NULL, NULL, '2025-02-07', '07:00:00', '00:12:00', NULL, NULL, 'fasfda', 1, 1),
(75, 21, 1, NULL, 3, NULL, '[{\"passenger\":\"12qweee\",\"contact\":\"fasdfasff\"}]', NULL, NULL, '2025-02-06', '06:15:00', '01:22:00', NULL, NULL, NULL, 0, 0),
(76, 15, 1, NULL, 3, NULL, '[{\"passenger\":\"fasdfa\",\"contact\":\"sfasfasfa\"}]', NULL, NULL, '2025-02-08', '06:15:00', '03:03:00', NULL, NULL, 'asfdas', 1, 1),
(77, 18, 1, NULL, 2, NULL, '[{\"passenger\":\"fasdfa\",\"contact\":\"fasdfasf\"}]', NULL, NULL, '2025-02-07', '08:00:00', '00:10:00', NULL, NULL, 'asf', 1, 1),
(78, 18, 1, NULL, 2, NULL, '[{\"passenger\":\"sxfasdfas\",\"contact\":\"fasdfasdfa\"}]', NULL, NULL, '2025-02-07', '08:30:00', '12:33:00', NULL, NULL, NULL, 0, 0),
(79, 18, 1, NULL, 3, NULL, '[{\"passenger\":\"fasdfasf\",\"contact\":\"asfasfasfa\"}]', NULL, NULL, '2025-02-07', '09:00:00', '12:03:00', NULL, NULL, '3fs', 1, 1),
(80, 21, 1, NULL, 2, NULL, '[{\"passenger\":\"Maria das Dores nas Costas\",\"contact\":\"12345678941\"}]', NULL, NULL, '2025-02-06', '06:00:00', '00:15:00', NULL, NULL, NULL, 0, 0),
(81, 18, 1, NULL, 3, NULL, '[{\"passenger\":\"3432423\",\"contact\":\"423424243\"}]', NULL, NULL, '2025-02-07', '06:30:00', '11:00:00', NULL, NULL, NULL, 0, 0),
(82, 18, 1, NULL, 4, NULL, '[{\"passenger\":\"asfasdf\",\"contact\":\"32442342\"}]', NULL, NULL, '2025-02-07', '06:45:00', '00:11:00', NULL, NULL, 'sdafas', 0, 0),
(83, 22, 1, NULL, 3, NULL, '[{\"passenger\":\"Manio\",\"contact\":\"12345678\"}]', NULL, NULL, '2025-02-08', '06:00:00', '00:15:00', NULL, NULL, 'sdfa', 0, 0),
(84, 22, 1, NULL, 2, NULL, '[{\"passenger\":\"Materiais\",\"contact\":\"12345678\"}]', NULL, NULL, '2025-02-08', '06:15:00', '00:01:00', NULL, NULL, 'Troca de materiais', 0, 0),
(85, 18, 1, NULL, 4, NULL, '[{\"passenger\":\"Casca de Bala\",\"contact\":\"00111406\"}]', NULL, NULL, '2025-02-07', '07:00:00', '01:25:00', NULL, NULL, NULL, 0, 0),
(86, 17, 3, NULL, 2, NULL, '[{\"passenger\":\"Oi Ninja!\",\"contact\":\"12345678\"}]', NULL, NULL, '2025-02-05', '15:00:00', '00:30:00', NULL, NULL, 'Nada', 0, 1),
(87, 17, 1, NULL, 4, NULL, '[{\"passenger\":\"Alguem\",\"contact\":\"45871254\"}]', NULL, NULL, '2025-02-05', '15:15:00', '00:15:00', NULL, NULL, NULL, 0, 0),
(88, 21, 1, NULL, 5, NULL, '[{\"passenger\":\"Maria Ana\",\"contact\":\"12345678\"}]', NULL, NULL, '2025-02-06', '09:15:00', '00:10:00', NULL, NULL, NULL, 1, 1),
(89, 20, 1, NULL, 5, NULL, '[{\"passenger\":\"Caca\",\"contact\":\"23456788\"}]', NULL, NULL, '2025-02-06', '12:00:00', '00:10:00', NULL, NULL, 'asdf', 0, 0),
(90, 21, 1, NULL, 5, NULL, '[{\"passenger\":\"Fada\",\"contact\":\"23423452345\"}]', NULL, NULL, '2025-02-06', '11:00:00', '11:02:00', NULL, NULL, 'asdf', 0, 0),
(91, 23, 5, NULL, 3, NULL, '[{\"passenger\":\"Mariana\",\"contact\":\"45698745\"}]', NULL, 'Nada a declarar', '2025-02-09', '18:42:54', '00:00:00', '2025-02-09 21:42:54', '2025-02-09 21:49:00', NULL, 0, 0),
(92, 23, 5, NULL, 1, NULL, '{}', NULL, 'Última rota do dia', '2025-02-09', '18:54:21', '00:00:00', '2025-02-09 21:54:21', '2025-02-09 22:04:59', NULL, 0, 0),
(93, 24, 1, NULL, 2, NULL, '[{\"passenger\":\"Maria\",\"contact\":\"27998298541\"}]', NULL, NULL, '2025-02-19', '07:30:00', '00:25:00', NULL, NULL, NULL, 1, 1),
(94, 25, 1, NULL, 3, NULL, '[{\"passenger\":\"Maria\",\"contact\":\"12345678\"}]', NULL, NULL, '2025-02-21', '07:00:00', '00:00:00', NULL, NULL, NULL, 1, 1),
(95, 26, 1, NULL, 6, NULL, '[{\"passenger\":\"Musk\",\"contact\":\"987453211\"}]', NULL, NULL, '2025-02-20', '23:30:00', '12:01:00', NULL, NULL, NULL, 1, 1),
(96, 27, 1, NULL, 7, NULL, '[{\"passenger\":\"Mano Brow\",\"contact\":\"2789784521\"}]', NULL, NULL, '2025-02-20', '23:15:00', '01:00:00', NULL, NULL, NULL, 1, 1),
(97, 27, 1, NULL, 4, NULL, '[{\"passenger\":\"Messias\",\"contact\":\"278587891\"}]', NULL, NULL, '2025-02-20', '22:00:00', '01:20:00', NULL, NULL, NULL, 1, 1),
(98, 27, 1, NULL, 3, NULL, '[{\"passenger\":\"Teste de atualiza\\u00e7\\u00e3o\",\"contact\":\"2748458645\"}]', NULL, NULL, '2025-02-20', '22:30:00', '13:00:00', NULL, NULL, NULL, 1, 1),
(99, 28, 1, NULL, 2, NULL, '[{\"passenger\":\"Malu\",\"contact\":\"321456987\"}]', NULL, NULL, '2025-02-21', '07:45:00', '12:01:00', NULL, NULL, 'obs', 1, 1),
(100, 26, 1, NULL, 5, NULL, '[{\"passenger\":\"Mot\\u00f4\",\"contact\":\"279878987\"}]', NULL, NULL, '2025-02-20', '20:45:00', '12:00:00', NULL, NULL, NULL, 0, 0),
(101, 29, 1, NULL, 2, NULL, '[{\"passenger\":\"Monica\",\"contact\":\"124458798\"}]', NULL, NULL, '2025-02-22', '18:00:00', '01:00:00', NULL, NULL, NULL, 0, 0),
(102, 30, 5, NULL, 5, NULL, '[{\"passenger\":\"Mot\\u00f4\",\"contact\":\"278987980\"}]', 'Guardar na garagem.', NULL, '2025-02-23', '18:02:38', '00:00:00', '2025-02-23 21:02:38', '2025-02-23 21:03:07', NULL, 0, 0),
(103, 30, 5, NULL, 1, NULL, '[{\"passenger\":\"Mot\\u00f4\",\"contact\":\"279898584\"}]', 'Testar Troca de carro...', NULL, '2025-02-23', '18:03:53', '00:00:00', '2025-02-23 21:03:53', '2025-02-23 21:04:58', NULL, 0, 0),
(104, 30, 5, NULL, 5, NULL, '[{\"passenger\":\"Mot\\u00f4\",\"contact\":\"279898787\"}]', NULL, NULL, '2025-02-23', '18:05:54', '00:00:00', '2025-02-23 21:05:54', '2025-02-23 21:06:35', NULL, 0, 0),
(105, 31, 4, NULL, 5, NULL, '{}', 'Guardar na aragem.', NULL, '2025-03-04', '20:23:42', '00:00:00', '2025-03-04 23:23:42', '2025-03-04 23:26:25', NULL, 0, 0),
(106, 31, 1, NULL, 6, NULL, '[{\"passenger\":\"Mot\\u00f4\",\"contact\":\"27998887878\"}]', NULL, NULL, '2025-03-04', '21:00:00', '12:00:00', '2025-03-04 23:44:52', '2025-03-04 23:45:15', 'Trocar automóvel', 0, 0),
(107, 31, 1, NULL, 5, NULL, '[{\"passenger\":\"Mot\\u00f4\",\"contact\":\"11554987\"}]', NULL, NULL, '2025-03-04', '21:15:00', '12:00:00', '2025-03-04 23:45:50', '2025-03-04 23:46:21', 'Guardar novo carro', 1, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `schedules`
--

CREATE TABLE `schedules` (
  `driver` bigint UNSIGNED NOT NULL,
  `morning_start` time DEFAULT NULL,
  `morning_end` time DEFAULT NULL,
  `afternoon_start` time DEFAULT NULL,
  `afternoon_end` time DEFAULT NULL,
  `night_start` time DEFAULT NULL,
  `night_end` time DEFAULT NULL,
  `special_start` time DEFAULT NULL,
  `special_end` time DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `settings`
--

CREATE TABLE `settings` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `settings` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `settings`
--

INSERT INTO `settings` (`id`, `name`, `settings`, `updated_at`) VALUES
(1, 'general', '{\n                    \"canRegister\":\n                        [\"Registro: permitir registro de usuário sem a necessidade de estar logado.\",false],\n                    \"mustVerifyEmail\":\n                        [\"Validação de e-mail: todo usuário registrado deverá verificar seu e-mail antes de poder utilizar o sistema.\",true],\n                    \"logoutAfterChangeEmail\":\n                        [\"Alteração de e-mail: se usuário alterar seu endereço de e-mail, deverá fazer uma nova verificação antes de prosseguir com uso do sistema.\",true],\n                    \"requireCpf\":\n                        [\"Exigir CPF no cadastro?\",true],\"saveUpdates\":{\"title\":\"Auditoria: quais dados devem ser salvos após alterados, para eventual auditoria?\",\n                    \"branches\":\n                        [\"Unidades\",true],\"clients\":[\"Clientes\",true],\"permissions\":[\"Permissões\",true],\"roles\":[\"Papéis\",true],\n                    \"userRolesPermissions\":\n                        [\"Controle de Acesso\",true],\n                    \"users\":\n                        [\"Usuários\",true]}}', '2025-01-16 22:38:12'),
(2, 'styles', '{\"main\":{\"body\":\"text-slate-100 dark:text-gray-300 bg-blue-900 dark:bg-gray-800\",\"container\":\"text-blue-800 dark:text-gray-300 bg-gray-100 dark:bg-gray-800\",\"subSection\":\"text-blue-800 dark:text-gray-200 bg-gray-100 dark:bg-gray-700\",\"innerSectionIcons\":\"text-amber-500 dark:text-yellow-100 hover:text-teal-200 dark:hover:text-yellow-200\",\"innerSection\":\"text-blue-700 dark:text-gray-300 bg-gray-100 dark:bg-gray-700\",\"formsStyles\":\"text-green-800 dark:text-slate-700 bg-teal-300 dark:bg-gray-400\",\"footer\":\"text-slate-200 dark:text-slate-50 bg-blue-900 dark:bg-gray-900\",\"footerLinks\":\"text-green-300 dark:text-yellow-400 hover:text-slate-500 dark:hover:text-white\"},\"mainMenu\":{\"body\":\"bg-blue-900 dark:bg-gray-900\",\"icons\":\"text-teal-100 dark:text-slate-200 hover:text-teal-600 dark:hover:text-slate-600\",\"iconsActive\":\"text-amber-500 dark:text-yellow-300 hover:text-amber-700 dark:hover:text-yellow-500\"},\"aclMenu\":{\"body\":\"text-gray-700 dark:text-white bg-white dark:bg-gray-700\",\"icons\":\"text-yellow-700 dark:text-green-600 hover:text-white dark:hover:text-red-700\"}}', '2025-02-06 11:39:55');

-- --------------------------------------------------------

--
-- Estrutura para tabela `setting_updates`
--

CREATE TABLE `setting_updates` (
  `id` bigint UNSIGNED NOT NULL,
  `updates` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tasks`
--

CREATE TABLE `tasks` (
  `id` bigint UNSIGNED NOT NULL,
  `driver` bigint UNSIGNED NOT NULL,
  `obs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `tasks`
--

INSERT INTO `tasks` (`id`, `driver`, `obs`, `date`) VALUES
(14, 5, NULL, '2025-02-04'),
(15, 2, NULL, '2025-02-04'),
(16, 4, NULL, '2025-02-04'),
(17, 4, NULL, '2025-02-05'),
(18, 4, NULL, '2025-02-07'),
(19, 5, NULL, '2025-02-07'),
(20, 5, NULL, '2025-02-06'),
(21, 4, NULL, '2025-02-06'),
(22, 4, NULL, '2025-02-08'),
(23, 5, NULL, '2025-02-09'),
(24, 5, NULL, '2025-02-19'),
(25, 5, NULL, '2025-02-21'),
(26, 5, NULL, '2025-02-20'),
(27, 4, NULL, '2025-02-20'),
(28, 4, NULL, '2025-02-21'),
(29, 5, NULL, '2025-02-22'),
(30, 5, NULL, '2025-02-23'),
(31, 4, NULL, '2025-03-04');

-- --------------------------------------------------------

--
-- Estrutura para tabela `timetables`
--

CREATE TABLE `timetables` (
  `id` bigint UNSIGNED NOT NULL,
  `time` time NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `timetables`
--

INSERT INTO `timetables` (`id`, `time`, `deleted_at`) VALUES
(1, '06:00:00', NULL),
(2, '06:15:00', NULL),
(3, '06:30:00', NULL),
(4, '06:45:00', NULL),
(5, '07:00:00', NULL),
(6, '07:15:00', NULL),
(7, '07:30:00', NULL),
(8, '07:45:00', NULL),
(9, '08:00:00', NULL),
(10, '08:15:00', NULL),
(11, '08:30:00', NULL),
(12, '08:45:00', NULL),
(13, '09:00:00', NULL),
(14, '09:15:00', NULL),
(15, '09:30:00', NULL),
(16, '09:45:00', NULL),
(17, '10:00:00', NULL),
(18, '10:15:00', NULL),
(19, '10:30:00', NULL),
(20, '10:45:00', NULL),
(21, '11:00:00', NULL),
(22, '11:15:00', NULL),
(23, '11:30:00', NULL),
(24, '11:45:00', NULL),
(25, '12:00:00', NULL),
(26, '12:15:00', NULL),
(27, '12:30:00', NULL),
(28, '12:45:00', NULL),
(29, '13:00:00', NULL),
(30, '13:15:00', NULL),
(31, '13:30:00', NULL),
(32, '13:45:00', NULL),
(33, '14:00:00', NULL),
(34, '14:15:00', NULL),
(35, '14:30:00', NULL),
(36, '14:45:00', NULL),
(37, '15:00:00', NULL),
(38, '15:15:00', NULL),
(39, '15:30:00', NULL),
(40, '15:45:00', NULL),
(41, '16:00:00', NULL),
(42, '16:15:00', NULL),
(43, '16:30:00', NULL),
(44, '16:45:00', NULL),
(45, '17:00:00', NULL),
(46, '17:15:00', NULL),
(47, '17:30:00', NULL),
(48, '17:45:00', NULL),
(49, '18:00:00', NULL),
(50, '18:15:00', NULL),
(51, '18:30:00', NULL),
(52, '18:45:00', NULL),
(53, '19:00:00', NULL),
(54, '19:15:00', NULL),
(55, '19:30:00', NULL),
(56, '19:45:00', NULL),
(57, '20:00:00', NULL),
(58, '20:15:00', NULL),
(59, '20:30:00', NULL),
(60, '20:45:00', NULL),
(61, '21:00:00', NULL),
(62, '21:15:00', NULL),
(63, '21:30:00', NULL),
(64, '21:45:00', NULL),
(65, '22:00:00', NULL),
(66, '22:15:00', NULL),
(67, '22:30:00', NULL),
(68, '22:45:00', NULL),
(69, '23:00:00', NULL),
(70, '23:15:00', NULL),
(71, '23:30:00', NULL),
(72, '23:45:00', NULL),
(73, '00:00:00', NULL),
(74, '00:15:00', NULL),
(75, '00:30:00', NULL),
(76, '00:45:00', NULL),
(77, '01:00:00', NULL),
(78, '01:15:00', NULL),
(79, '01:30:00', NULL),
(80, '01:45:00', NULL),
(81, '02:00:00', NULL),
(82, '02:15:00', NULL),
(83, '02:30:00', NULL),
(84, '02:45:00', NULL),
(85, '03:00:00', NULL),
(86, '03:15:00', NULL),
(87, '03:30:00', NULL),
(88, '03:45:00', NULL),
(89, '04:00:00', NULL),
(90, '04:15:00', NULL),
(91, '04:30:00', NULL),
(92, '04:45:00', NULL),
(93, '05:00:00', NULL),
(94, '05:15:00', NULL),
(95, '05:30:00', NULL),
(96, '05:45:00', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cpf` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `branch_id` bigint UNSIGNED DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_secret` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `two_factor_recovery_codes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `cpf`, `branch_id`, `notes`, `email_verified_at`, `password`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Super Admin', 'crebs@crebs.dev', '11736707779', NULL, 'Default User', '2025-01-16 22:38:12', '$2y$12$BhF5T93.4ygycHaknuLgZeTkngSEZHPt0i4oCXc5cD.hAQ0OG1zkC', NULL, NULL, NULL, 'Y9nIjJmDp1Om5ktGrwBABOT6f0cgFMiTtu59yURQdtSK3XtfDXVQmAbn9OpF', '2025-01-16 22:38:12', '2025-01-16 22:38:12', NULL),
(2, '-', '-', '', NULL, NULL, '2025-01-16 22:53:00', '$2y$12$gs6KzYo6BAEj.gQ6TKomQ.JPUOpyCPrhNRXK/xHz7jBQXepmCOnAW', NULL, NULL, NULL, 'RDvTF0mG2sGJkPHyi7jbQWN2vDCghBoXGCHODXuKVsxt9ZT5zPcFmxjc0Nvb', '2025-01-16 22:52:44', '2025-01-16 22:53:12', NULL),
(3, 'Usuario Um', 'usuarioum@email.com', '56528145784', NULL, NULL, '2025-01-19 11:40:57', '$2y$12$08dWw7wEraRG47swgQiGouzuRLmtSNN29n4P/4CoWVqqWPROtM7bm', NULL, NULL, NULL, 'Ikch8vAuZteZLVdjo7kR9kWQG0acserqeRigKaMb6ymMUafsGH3UjnNm8cLq', '2025-01-19 11:40:45', '2025-01-19 12:35:47', NULL),
(4, 'Motorista Tres', 'motoristatres@email.com', '31290354863', NULL, NULL, '2025-01-26 21:03:18', '$2y$12$rhz5TP4.EbX0u4o9.1HfmOZry1MEB6JSMk0tBMXmTx4PVS0EqtbZm', NULL, NULL, NULL, 'sLyXITE3Y4yCBSoVyb4DuolFd0HsKiXMNgXo6ISa1eLsyjD4JEyed2DAMUDK', '2025-01-26 21:03:06', '2025-01-26 21:03:18', NULL),
(5, 'Motorista Um', 'motoristaum@email.com', '51611338565', NULL, NULL, '2025-01-16 22:53:00', '$2y$12$gs6KzYo6BAEj.gQ6TKomQ.JPUOpyCPrhNRXK/xHz7jBQXepmCOnAW', NULL, NULL, NULL, 'WxyUXRKb45yH8K6FJYWz2HNmeaJdFA2QvXR46ziyH4iYzup55Fvqvf2gCNId', '2025-01-16 22:52:44', '2025-01-16 22:53:12', NULL),
(6, 'Liberador Um', 'liberadorum@email.com', '76113458008', NULL, 'Testar funcionamento do APP e dos menus', '2025-02-22 16:46:23', '$2y$12$VTH67K70i7RQcUcg6h5CeeOlm9E2V8/i2mJpYdIdx2dkpMrpIL5Fq', NULL, NULL, NULL, 'P5x3b9wprpgY3w9igu90hJTRKwBnFxQ3kQfCgBnQcbRwavNTilOyGxkJL6cx', '2025-02-22 16:46:11', '2025-02-22 16:46:23', NULL),
(7, 'Motorista Dois', 'motoristadois@email.com', '35696275001', NULL, NULL, NULL, '$2y$12$3nPlKHSGvalT7J2VgbY3zeQilA6zkiTze.XukksU/52Mu1pirSN2y', NULL, NULL, NULL, NULL, '2025-02-23 23:21:12', '2025-02-23 23:21:12', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_updates`
--

CREATE TABLE `user_updates` (
  `id` bigint UNSIGNED NOT NULL,
  `updates` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `user_updates`
--

INSERT INTO `user_updates` (`id`, `updates`, `updated_at`) VALUES
(2, '{\"user_id\":[0,1,1],\"name\":[\"Motorista Um\",\"Motorista Um\",\"Motorista Um\"],\"email\":[\"motoristaum@email.com\",\"motoristaum@email.com\",\"motoristaum@email.com\"],\"cpf\":[\"51611338565\",\"51611338565\",\"51611338565\"],\"branch_id\":[null,null,null],\"notes\":[null,null,null],\"email_verified_at\":[null,\"2025-01-16T22:53:00.000000Z\",\"2025-01-16T22:53:00.000000Z\"],\"updated_at\":[\"2025-01-16 22:52:44\",\"2025-01-16 22:53:00\",\"2025-01-16 22:53:12\"],\"deleted_at\":[null,null,null]}', '2025-01-16 22:53:12'),
(3, '{\"user_id\":[0,1,1],\"name\":[\"Usuario Um\",\"Usuario Um\",\"Usuario Um\"],\"email\":[\"usuarioum@email.com\",\"usuarioum@email.com\",\"usuarioum@email.com\"],\"cpf\":[\"56528145784\",\"56528145784\",\"56528145784\"],\"branch_id\":[null,null,null],\"notes\":[null,null,null],\"email_verified_at\":[null,\"2025-01-19T11:40:57.000000Z\",\"2025-01-19T11:40:57.000000Z\"],\"updated_at\":[\"2025-01-19 11:40:45\",\"2025-01-19 11:40:57\",\"2025-01-19 12:35:47\"],\"deleted_at\":[null,null,null]}', '2025-01-19 12:35:47'),
(4, '{\"user_id\":[0,1,1],\"name\":[\"Motorista Tres\",\"Motorista Tres\",\"Motorista Tres\"],\"email\":[\"motoristatres@email.com\",\"motoristatres@email.com\",\"motoristatres@email.com\"],\"cpf\":[\"31290354863\",\"31290354863\",\"31290354863\"],\"branch_id\":[null,null,null],\"notes\":[null,null,null],\"email_verified_at\":[null,null,\"2025-01-26T21:03:18.000000Z\"],\"updated_at\":[\"2025-01-26 21:03:06\",\"2025-01-26 21:03:16\",\"2025-01-26 21:03:18\"],\"deleted_at\":[null,null,null]}', '2025-01-26 21:03:18'),
(6, '{\"user_id\":[0,1,1],\"name\":[\"Liberador Um\",\"Liberador Um\",\"Liberador Um\"],\"email\":[\"liberadorum@email.com\",\"liberadorum@email.com\",\"liberadorum@email.com\"],\"cpf\":[\"76113458008\",\"76113458008\",\"76113458008\"],\"branch_id\":[null,null,null],\"notes\":[\"Testar funcionamento do APP e dos menus\",\"Testar funcionamento do APP e dos menus\",\"Testar funcionamento do APP e dos menus\"],\"email_verified_at\":[null,null,\"2025-02-22T16:46:23.000000Z\"],\"updated_at\":[\"2025-02-22 16:46:11\",\"2025-02-22 16:46:20\",\"2025-02-22 16:46:23\"],\"deleted_at\":[null,null,null]}', '2025-02-22 16:46:23');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `acl_updates`
--
ALTER TABLE `acl_updates`
  ADD UNIQUE KEY `acl_updates_id_unique` (`id`);

--
-- Índices de tabela `attaches`
--
ALTER TABLE `attaches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attaches_maintenance_id_foreign` (`maintenance_id`);

--
-- Índices de tabela `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `branches_cnpj_unique` (`cnpj`);

--
-- Índices de tabela `branch_updates`
--
ALTER TABLE `branch_updates`
  ADD UNIQUE KEY `branch_updates_id_unique` (`id`);

--
-- Índices de tabela `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Índices de tabela `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Índices de tabela `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cars_placa_unique` (`placa`),
  ADD KEY `cars_garagem_id_foreign` (`garagem_id`);

--
-- Índices de tabela `cars_log`
--
ALTER TABLE `cars_log`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cars_log_route_type_unique` (`route`,`type`),
  ADD KEY `cars_log_car_foreign` (`car`);

--
-- Índices de tabela `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clients_cpf_unique` (`cpf`),
  ADD KEY `clients_branch_id_foreign` (`branch_id`);

--
-- Índices de tabela `client_updates`
--
ALTER TABLE `client_updates`
  ADD UNIQUE KEY `client_updates_id_unique` (`id`);

--
-- Índices de tabela `drivers`
--
ALTER TABLE `drivers`
  ADD UNIQUE KEY `drivers_id_unique` (`id`),
  ADD KEY `drivers_garagem_id_foreign` (`garagem_id`),
  ADD KEY `drivers_carro_favorito_foreign` (`carro_favorito`);

--
-- Índices de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Índices de tabela `fuels`
--
ALTER TABLE `fuels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fuels_car_foreign` (`car`),
  ADD KEY `fuels_driver_foreign` (`driver`);

--
-- Índices de tabela `garages`
--
ALTER TABLE `garages`
  ADD UNIQUE KEY `garages_id_unique` (`id`);

--
-- Índices de tabela `incidents`
--
ALTER TABLE `incidents`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Índices de tabela `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `justifications`
--
ALTER TABLE `justifications`
  ADD UNIQUE KEY `justifications_route_unique` (`route`),
  ADD KEY `justifications_user_foreign` (`user`);

--
-- Índices de tabela `maintenances`
--
ALTER TABLE `maintenances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `maintenance_car_foreign` (`car`);

--
-- Índices de tabela `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Índices de tabela `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Índices de tabela `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Índices de tabela `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Índices de tabela `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Índices de tabela `permission_updates`
--
ALTER TABLE `permission_updates`
  ADD UNIQUE KEY `permission_updates_id_unique` (`id`);

--
-- Índices de tabela `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Índices de tabela `real_branches`
--
ALTER TABLE `real_branches`
  ADD UNIQUE KEY `real_branches_route_unique` (`route`);

--
-- Índices de tabela `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `requests_driver_foreign` (`driver`),
  ADD KEY `requests_user_foreign` (`user`),
  ADD KEY `requests_mediator_foreign` (`mediator`),
  ADD KEY `requests_to_foreign` (`to`);

--
-- Índices de tabela `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Índices de tabela `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Índices de tabela `role_updates`
--
ALTER TABLE `role_updates`
  ADD UNIQUE KEY `role_updates_id_unique` (`id`);

--
-- Índices de tabela `routes`
--
ALTER TABLE `routes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `routes_task_foreign` (`task`),
  ADD KEY `routes_user_foreign` (`user`),
  ADD KEY `routes_to_foreign` (`to`),
  ADD KEY `routes_mediator_foreign` (`mediator`);

--
-- Índices de tabela `schedules`
--
ALTER TABLE `schedules`
  ADD UNIQUE KEY `schedules_driver_unique` (`driver`);

--
-- Índices de tabela `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Índices de tabela `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_name_unique` (`name`);

--
-- Índices de tabela `setting_updates`
--
ALTER TABLE `setting_updates`
  ADD UNIQUE KEY `setting_updates_id_unique` (`id`);

--
-- Índices de tabela `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tasks_driver_foreign` (`driver`);

--
-- Índices de tabela `timetables`
--
ALTER TABLE `timetables`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_cpf_unique` (`cpf`),
  ADD KEY `users_branch_id_foreign` (`branch_id`);

--
-- Índices de tabela `user_updates`
--
ALTER TABLE `user_updates`
  ADD UNIQUE KEY `user_updates_id_unique` (`id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `attaches`
--
ALTER TABLE `attaches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `branches`
--
ALTER TABLE `branches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `cars`
--
ALTER TABLE `cars`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `cars_log`
--
ALTER TABLE `cars_log`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de tabela `clients`
--
ALTER TABLE `clients`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `fuels`
--
ALTER TABLE `fuels`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de tabela `incidents`
--
ALTER TABLE `incidents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `maintenances`
--
ALTER TABLE `maintenances`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de tabela `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT de tabela `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `requests`
--
ALTER TABLE `requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de tabela `routes`
--
ALTER TABLE `routes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT de tabela `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de tabela `timetables`
--
ALTER TABLE `timetables`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `acl_updates`
--
ALTER TABLE `acl_updates`
  ADD CONSTRAINT `acl_updates_id_foreign` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `attaches`
--
ALTER TABLE `attaches`
  ADD CONSTRAINT `attaches_maintenance_id_foreign` FOREIGN KEY (`maintenance_id`) REFERENCES `maintenances` (`id`);

--
-- Restrições para tabelas `branch_updates`
--
ALTER TABLE `branch_updates`
  ADD CONSTRAINT `branch_updates_id_foreign` FOREIGN KEY (`id`) REFERENCES `branches` (`id`);

--
-- Restrições para tabelas `cars`
--
ALTER TABLE `cars`
  ADD CONSTRAINT `cars_garagem_id_foreign` FOREIGN KEY (`garagem_id`) REFERENCES `garages` (`id`);

--
-- Restrições para tabelas `cars_log`
--
ALTER TABLE `cars_log`
  ADD CONSTRAINT `cars_log_car_foreign` FOREIGN KEY (`car`) REFERENCES `cars` (`id`),
  ADD CONSTRAINT `cars_log_route_foreign` FOREIGN KEY (`route`) REFERENCES `routes` (`id`);

--
-- Restrições para tabelas `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`);

--
-- Restrições para tabelas `client_updates`
--
ALTER TABLE `client_updates`
  ADD CONSTRAINT `client_updates_id_foreign` FOREIGN KEY (`id`) REFERENCES `clients` (`id`);

--
-- Restrições para tabelas `drivers`
--
ALTER TABLE `drivers`
  ADD CONSTRAINT `drivers_carro_favorito_foreign` FOREIGN KEY (`carro_favorito`) REFERENCES `cars` (`id`),
  ADD CONSTRAINT `drivers_garagem_id_foreign` FOREIGN KEY (`garagem_id`) REFERENCES `garages` (`id`),
  ADD CONSTRAINT `drivers_id_foreign` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `fuels`
--
ALTER TABLE `fuels`
  ADD CONSTRAINT `fuels_car_foreign` FOREIGN KEY (`car`) REFERENCES `cars` (`id`),
  ADD CONSTRAINT `fuels_driver_foreign` FOREIGN KEY (`driver`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `garages`
--
ALTER TABLE `garages`
  ADD CONSTRAINT `garages_id_foreign` FOREIGN KEY (`id`) REFERENCES `branches` (`id`);

--
-- Restrições para tabelas `justifications`
--
ALTER TABLE `justifications`
  ADD CONSTRAINT `justifications_route_foreign` FOREIGN KEY (`route`) REFERENCES `routes` (`id`),
  ADD CONSTRAINT `justifications_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `maintenances`
--
ALTER TABLE `maintenances`
  ADD CONSTRAINT `maintenance_car_foreign` FOREIGN KEY (`car`) REFERENCES `cars` (`id`);

--
-- Restrições para tabelas `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `permission_updates`
--
ALTER TABLE `permission_updates`
  ADD CONSTRAINT `permission_updates_id_foreign` FOREIGN KEY (`id`) REFERENCES `permissions` (`id`);

--
-- Restrições para tabelas `real_branches`
--
ALTER TABLE `real_branches`
  ADD CONSTRAINT `real_branches_route_foreign` FOREIGN KEY (`route`) REFERENCES `routes` (`id`);

--
-- Restrições para tabelas `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_driver_foreign` FOREIGN KEY (`driver`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `requests_mediator_foreign` FOREIGN KEY (`mediator`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `requests_to_foreign` FOREIGN KEY (`to`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `requests_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `role_updates`
--
ALTER TABLE `role_updates`
  ADD CONSTRAINT `role_updates_id_foreign` FOREIGN KEY (`id`) REFERENCES `roles` (`id`);

--
-- Restrições para tabelas `routes`
--
ALTER TABLE `routes`
  ADD CONSTRAINT `routes_mediator_foreign` FOREIGN KEY (`mediator`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `routes_task_foreign` FOREIGN KEY (`task`) REFERENCES `tasks` (`id`),
  ADD CONSTRAINT `routes_to_foreign` FOREIGN KEY (`to`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `routes_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `schedules_driver_foreign` FOREIGN KEY (`driver`) REFERENCES `drivers` (`id`);

--
-- Restrições para tabelas `setting_updates`
--
ALTER TABLE `setting_updates`
  ADD CONSTRAINT `setting_updates_id_foreign` FOREIGN KEY (`id`) REFERENCES `settings` (`id`);

--
-- Restrições para tabelas `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_driver_foreign` FOREIGN KEY (`driver`) REFERENCES `drivers` (`id`);

--
-- Restrições para tabelas `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`);

--
-- Restrições para tabelas `user_updates`
--
ALTER TABLE `user_updates`
  ADD CONSTRAINT `user_updates_id_foreign` FOREIGN KEY (`id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
