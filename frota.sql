-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Tempo de geração: 01/04/2025 às 18:14
-- Versão do servidor: 8.0.37
-- Versão do PHP: 8.3.1

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
-- Estrutura para tabela `agendamentos`
--

CREATE TABLE `agendamentos` (
  `id` bigint UNSIGNED NOT NULL,
  `agenda` bigint UNSIGNED NOT NULL,
  `CodRequisicao` int UNSIGNED NOT NULL,
  `CodExameLaboratorial` int UNSIGNED NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendas`
--

CREATE TABLE `agendas` (
  `id` bigint UNSIGNED NOT NULL,
  `user` bigint UNSIGNED NOT NULL,
  `posto_coleta` int UNSIGNED NOT NULL,
  `vigencia_inicio` date NOT NULL,
  `vigencia_fim` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fim` time NOT NULL,
  `intervalo` tinyint NOT NULL,
  `vagas` tinyint NOT NULL,
  `alteracoes` text COLLATE utf8mb4_unicode_ci,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `agendas`
--

INSERT INTO `agendas` (`id`, `user`, `posto_coleta`, `vigencia_inicio`, `vigencia_fim`, `hora_inicio`, `hora_fim`, `intervalo`, `vagas`, `alteracoes`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 4, '2025-04-01', '2025-04-30', '07:00:00', '10:00:00', 0, 25, '[{\"user\":\"Super Admin\",\"vagas\":25,\"intervalo\":0,\"data\":\"2025-03-31 15:08:54\",\"vigencia_inicio\":\"2025-04-01\",\"vigencia_fim\":\"2025-04-30\",\"hora_inicio\":\"07:00:00\",\"hora_fim\":\"10:00:00\"},{\"user\":\"Super Admin\",\"vagas\":25,\"intervalo\":\"0\",\"data\":\"2025-04-01 14:30:03\",\"vigencia_inicio\":\"2025-04-01\",\"vigencia_fim\":\"2025-04-30\",\"hora_inicio\":\"07:00:00\",\"hora_fim\":\"10:00:00\"}]', NULL, '2025-03-31 18:08:54', '2025-04-01 17:30:03'),
(2, 1, 7, '2025-04-01', '2025-04-15', '07:00:00', '07:00:00', 5, 20, '[{\"user\":\"Super Admin\",\"valor\":null,\"data\":\"2025-04-01 14:16:46\",\"vigencia_inicio\":\"2025-04-01\",\"vigencia_fim\":\"2025-04-15\",\"hora_inicio\":\"07:00:00\",\"hora_fim\":\"07:00:00\"},{\"user\":\"Super Admin\",\"vagas\":\"20\",\"intervalo\":\"5\",\"data\":\"2025-04-01 14:25:25\",\"vigencia_inicio\":\"2025-04-01\",\"vigencia_fim\":\"2025-04-15\",\"hora_inicio\":\"07:00:00\",\"hora_fim\":\"07:00:00\"}]', NULL, NULL, '2025-04-01 17:25:25'),
(3, 1, 9, '2025-04-01', '2025-04-15', '07:00:00', '07:00:00', 5, 18, '[{\"user\":\"Super Admin\",\"vagas\":20,\"intervalo\":0,\"data\":\"2025-04-01 14:30:48\",\"vigencia_inicio\":\"2025-04-01\",\"vigencia_fim\":\"2025-04-15\",\"hora_inicio\":\"07:00:54\",\"hora_fim\":\"07:00:54\"},{\"user\":\"Super Admin\",\"vagas\":\"18\",\"intervalo\":\"0\",\"data\":\"2025-04-01 14:30:56\",\"vigencia_inicio\":\"2025-04-01\",\"vigencia_fim\":\"2025-04-15\",\"hora_inicio\":\"07:00:00\",\"hora_fim\":\"07:00:00\"},{\"user\":\"Super Admin\",\"vagas\":\"18\",\"intervalo\":\"0\",\"data\":\"2025-04-01 14:30:58\",\"vigencia_inicio\":\"2025-04-01\",\"vigencia_fim\":\"2025-04-15\",\"hora_inicio\":\"07:00:00\",\"hora_fim\":\"07:00:00\"},{\"user\":\"Super Admin\",\"vagas\":18,\"intervalo\":\"5\",\"data\":\"2025-04-01 14:31:21\",\"vigencia_inicio\":\"2025-04-01\",\"vigencia_fim\":\"2025-04-15\",\"hora_inicio\":\"07:00:00\",\"hora_fim\":\"07:00:00\"}]', '2025-04-01 18:10:17', NULL, '2025-04-01 18:10:17'),
(4, 1, 8, '2025-04-01', '2025-04-04', '07:00:00', '07:00:00', 0, 30, NULL, NULL, NULL, NULL),
(5, 1, 8, '2025-04-07', '2025-04-11', '07:00:00', '07:00:00', 0, 20, NULL, '2025-04-01 18:09:33', NULL, '2025-04-01 18:09:33'),
(6, 1, 7, '2025-04-16', '2025-04-30', '12:37:00', '12:37:00', 1, 18, NULL, '2025-04-01 18:08:21', NULL, '2025-04-01 18:08:21');

-- --------------------------------------------------------

--
-- Estrutura para tabela `attaches`
--

CREATE TABLE `attaches` (
  `id` bigint UNSIGNED NOT NULL,
  `maintenance_id` bigint UNSIGNED NOT NULL,
  `type` int NOT NULL,
  `filename` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
(7, 'US Paul', NULL, NULL, NULL, NULL, NULL, 'Praça de Paul', NULL, '2025-02-14 00:05:19', '2025-02-14 00:05:19'),
(8, 'US Ponta da Fruta', NULL, NULL, NULL, NULL, NULL, 'Pŕoxima a Lagoa', NULL, '2025-03-25 21:16:34', '2025-03-25 21:16:34'),
(9, 'US Ibes', NULL, NULL, NULL, NULL, NULL, 'Próximo a praça do Ibes', NULL, '2025-03-25 21:17:16', '2025-03-25 21:17:16');

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
-- Estrutura para tabela `contratos`
--

CREATE TABLE `contratos` (
  `id` bigint UNSIGNED NOT NULL,
  `user` bigint UNSIGNED NOT NULL,
  `contrato` int NOT NULL,
  `ano` int NOT NULL,
  `contratada_nome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contratada_cnpj` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contratante` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vigencia_inicio` date NOT NULL,
  `vigencia_fim` date NOT NULL,
  `valor_global` decimal(11,2) NOT NULL,
  `aditivos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `descricao` varchar(550) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ativo` tinyint(1) NOT NULL,
  `versao` tinyint NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `contratos`
--

INSERT INTO `contratos` (`id`, `user`, `contrato`, `ano`, `contratada_nome`, `contratada_cnpj`, `contratante`, `vigencia_inicio`, `vigencia_fim`, `valor_global`, `aditivos`, `descricao`, `ativo`, `versao`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 241, 2022, 'Target Soluções Inteligentes', '22840676000126', 'SEMSA/FMS', '2024-03-22', '2025-03-22', 1000000.00, '[]', 'Unidades A, B e C\nContrato inicial de R$ 1.000.000,00\nReajuste e 1º aditivo em 22/03/2025', 1, 1, NULL, '2025-03-22 12:12:04', '2025-03-27 17:21:17'),
(2, 1, 45987, 2025, 'Laboratório A', '24516876000153', 'FMS', '2025-03-07', '2026-03-22', 456987.15, NULL, 'Emergencial', 1, 1, NULL, '2025-03-22 14:07:37', '2025-03-22 14:10:33'),
(3, 1, 123654, 2024, 'Crebs Dev', '28328583000101', 'SEMSA', '2024-09-02', '2025-09-02', 1000500.00, NULL, 'Exames bioquímicos', 1, 1, NULL, '2025-03-26 19:44:56', '2025-03-26 19:44:56');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cotas_financeiras`
--

CREATE TABLE `cotas_financeiras` (
  `id` bigint UNSIGNED NOT NULL,
  `posto_coleta` bigint UNSIGNED NOT NULL,
  `contrato` bigint UNSIGNED NOT NULL,
  `user` bigint UNSIGNED NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `alteracoes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `inicio` date NOT NULL,
  `fim` date NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `cotas_financeiras`
--

INSERT INTO `cotas_financeiras` (`id`, `posto_coleta`, `contrato`, `user`, `valor`, `alteracoes`, `inicio`, `fim`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 1, 1000.00, '[{\"user\":\"Super Admin\",\"valor\":\"1000.00\",\"data\":\"2025-03-25 18:36:30\",\"inicio\":\"2025-04-01\",\"fim\":\"2025-04-30\"}]', '2025-04-01', '2025-04-30', NULL, '2025-03-25 21:36:30', '2025-03-27 18:02:43'),
(2, 8, 1, 1, 1000.31, '[{\"user\":\"Super Admin\",\"valor\":\"1000.25\",\"data\":\"2025-03-25 18:39:10\",\"inicio\":\"2025-03-27\",\"fim\":\"2025-04-30\"},{\"user\":\"Super Admin\",\"valor\":\"1000.27\",\"data\":\"2025-03-26 13:44:11\",\"inicio\":\"2025-03-27\",\"fim\":\"2025-04-30\"},{\"user\":\"Super Admin\",\"valor\":\"1000.28\",\"data\":\"2025-03-26 13:46:32\",\"inicio\":\"2025-03-27\",\"fim\":\"2025-04-30\"},{\"user\":\"Super Admin\",\"valor\":\"1000.29\",\"data\":\"2025-03-26 13:50:47\",\"inicio\":\"2025-03-27\",\"fim\":\"2025-04-30\"},{\"user\":\"Super Admin\",\"valor\":\"1000.30\",\"data\":\"2025-03-26 13:51:11\",\"inicio\":\"2025-03-27\",\"fim\":\"2025-04-30\"},{\"user\":\"Super Admin\",\"valor\":\"1000.31\",\"data\":\"2025-03-26 13:51:16\",\"inicio\":\"2025-03-27\",\"fim\":\"2025-04-30\"}]', '2025-03-27', '2025-04-30', NULL, '2025-03-25 21:39:10', '2025-03-26 16:51:16'),
(3, 8, 1, 1, 460.51, '[{\"user\":\"Super Admin\",\"valor\":\"456.35\",\"data\":\"2025-03-26 09:21:03\",\"inicio\":\"2025-03-01\",\"fim\":\"2025-03-15\"},{\"user\":\"Super Admin\",\"valor\":\"460.00\",\"data\":\"2025-03-26 14:03:57\",\"inicio\":\"2025-03-01\",\"fim\":\"2025-03-15\"},{\"user\":\"Super Admin\",\"valor\":\"460.50\",\"data\":\"2025-03-26 14:05:09\",\"inicio\":\"2025-03-01\",\"fim\":\"2025-03-15\"},{\"user\":\"Super Admin\",\"valor\":\"460.51\",\"data\":\"2025-03-26 14:08:23\",\"inicio\":\"2025-03-01\",\"fim\":\"2025-03-15\"}]', '2025-03-01', '2025-03-15', NULL, '2025-03-26 12:21:03', '2025-03-26 17:08:23'),
(4, 8, 1, 1, 460.51, NULL, '2025-04-01', '2025-04-30', NULL, '2025-03-26 17:35:11', '2025-03-26 17:35:11'),
(5, 7, 1, 1, 25780.00, NULL, '2025-03-27', '2025-12-31', NULL, '2025-03-27 18:12:55', '2025-03-27 18:12:55'),
(6, 7, 2, 1, 12344.40, NULL, '2025-03-28', '2025-03-29', NULL, '2025-03-27 18:17:00', '2025-03-27 18:17:00'),
(7, 9, 1, 1, 25435.43, NULL, '2025-03-27', '2025-03-29', NULL, '2025-03-27 18:18:19', '2025-03-27 18:18:19'),
(8, 9, 2, 1, 445.53, NULL, '2025-03-28', '2025-03-28', NULL, '2025-03-27 18:25:44', '2025-03-27 18:25:44'),
(9, 9, 3, 1, 1232.33, NULL, '2025-03-28', '2025-03-28', NULL, '2025-03-27 18:27:52', '2025-03-27 18:27:52'),
(10, 8, 3, 1, 123.00, '[{\"user\":\"Super Admin\",\"valor\":\"123.44\",\"data\":\"2025-03-27 15:31:20\",\"inicio\":\"2025-03-27\",\"fim\":\"2025-03-28\"}]', '2025-03-27', '2025-03-28', NULL, '2025-03-27 18:31:20', '2025-03-27 18:31:49');

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
-- Estrutura para tabela `exames_clinicos`
--

CREATE TABLE `exames_clinicos` (
  `id` bigint NOT NULL,
  `CodSetorExameLaboratorial` int DEFAULT NULL,
  `CodigoExterno` bigint DEFAULT NULL,
  `Sigla` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Descricao` varchar(155) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ExameParaProntoAtendimento` tinyint DEFAULT NULL,
  `ExameAutorizacaoPrevia` tinyint DEFAULT NULL,
  `InformarDataInicioSintoma` tinyint DEFAULT NULL,
  `GerarRequisicaoSeparado` tinyint DEFAULT NULL,
  `Ativo` tinyint DEFAULT NULL,
  `MensagemInformativa` tinyint DEFAULT NULL,
  `ExameParaLACEN` tinyint DEFAULT NULL,
  `Sexo` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `exames_clinicos`
--

INSERT INTO `exames_clinicos` (`id`, `CodSetorExameLaboratorial`, `CodigoExterno`, `Sigla`, `Descricao`, `ExameParaProntoAtendimento`, `ExameAutorizacaoPrevia`, `InformarDataInicioSintoma`, `GerarRequisicaoSeparado`, `Ativo`, `MensagemInformativa`, `ExameParaLACEN`, `Sexo`) VALUES
(1, 2, 202010023, 'CFIXFE', 'DETERMINACAO DE CAPACIDADE DE FIXACAO DO FERRO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(2, 2, 2020100741, 'CURVAGLI2', 'DETERMINACAO DE CURVA GLICEMICA CLASSICA (2 DOSAGENS) / TOTG', NULL, 0, 0, NULL, 1, NULL, 0, 'A'),
(3, 2, 202010074, 'CURVAGLI5', 'DETERMINACAO DE CURVA GLICEMICA CLASSICA (5 DOSAGENS)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(4, 4, 202060217, 'BHCG', 'DOSAGEM DE GONADOTROFINA CORIONICA HUMANA / HCG / BETA HCG ', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(5, 2, 202030083, 'QUANTPCR', 'DETERMINACAO QUANTITATIVA DE PROTEINA C REATIVA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(6, 2, 202010120, 'AURSANGUE', 'DOSAGEM DE ACIDO URICO NO SANGUE / URICEMIA / URATO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(7, 4, 202060225, 'HGH', 'DOSAGEM DE HORMONIO DE CRESCIMENTO / HGH', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(8, 2, 2020101201, 'AURURINA', 'DOSAGEM DE ACIDO URICO NA URINA / URICOSÚRIA / URATO', NULL, 0, 0, NULL, 1, NULL, 0, 'A'),
(9, 4, 202060233, 'FSH', 'DOSAGEM DE HORMONIO FOLICULO-ESTIMULANTE / FSH', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(10, 4, 202060241, 'LH', 'DOSAGEM DE HORMONIO LUTEINIZANTE / LH', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(11, 4, 202060250, 'TSH', 'DOSAGEM DE HORMONIO TIREOESTIMULANTE / TSH', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(12, 2, 202030091, 'AFP', 'DOSAGEM DE ALFA-FETOPROTEINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(13, 2, 202010163, 'ALFAGP', 'DOSAGEM DE ALFA-1-GLICOPROTEINA ACIDA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(14, 4, 202030105, 'PSA', 'DOSAGEM DE ANTIGENO PROSTATICO ESPECIFICO / PSA', 0, 0, 0, NULL, 1, NULL, 0, 'M'),
(15, 2, 202010180, 'AMI', 'DOSAGEM DE AMILASE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(16, 9, 202030121, 'C3', 'DOSAGEM DE COMPLEMENTO C3', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(17, 2, 202010201, 'BT', 'DOSAGEM DE BILIRRUBINA TOTAL E FRACOES / BT TOTAIS E FR', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(18, 9, 202030130, 'C4', 'DOSAGEM DE COMPLEMENTO C4', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(19, 2, 202010210, 'CASANGUE', 'DOSAGEM DE CALCIO / CA2+ / CALCEMIA / CÁLCIO TOTAL', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(20, 2, 2020102101, 'CAURINA24H', 'DOSAGEM DE CALCIO NA URINA DE 24H / CALCIURIA URINA DE 24H', NULL, 0, 0, NULL, 1, NULL, 0, 'A'),
(21, 2, 2020102102, 'CAURINAAI', 'DOSAGEM DE CALCIO NA URINA AMOSTRA ISOLADA / CALCIURIA AMOSTRA ISOLADA', NULL, 0, 0, NULL, 1, NULL, 0, 'A'),
(22, 2, 202010228, 'CALCION', 'DOSAGEM DE CALCIO IONIZAVEL', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(23, 2, 202010260, 'CL', 'DOSAGEM DE CLORETO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(24, 9, 202030156, 'IGA', 'DOSAGEM DE IMUNOGLOBULINA A (IGA)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(25, 9, 202030164, 'IGE', 'DOSAGEM DE IMUNOGLOBULINA E (IGE)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(26, 5, 202030180, 'IGM', 'DOSAGEM DE IMUNOGLOBULINA M (IGM)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(27, 2, 202030202, 'PCR', 'DOSAGEM DE PROTEINA C REATIVA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(28, 9, 202030253, 'IGGANTICARD', 'PESQUISA DE ANTICORPO IGG ANTICARDIOLIPINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(29, 9, 202030261, 'IGMANTICARD', 'PESQUISA DE ANTICORPO IGM ANTICARDIOLIPINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(30, 9, 202030270, 'ANTIDNA', 'PESQUISA DE ANTICORPOS ANTI-DNA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(31, 5, 202030300, 'HIV 1 E 2', 'PESQUISA DE ANTICORPOS ANTI-HIV-1 + HIV-2 (ELISA)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(32, 5, 202030318, 'HTLV 1 E 2', 'PESQUISA DE ANTICORPOS ANTI-HTLV-1 + HTLV-2', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(33, 9, 202030326, 'ANTIRNP', 'PESQUISA DE ANTICORPOS ANTI-RIBONUCLEOPROTEINA / ANTI-RNP', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(34, 9, 202030342, 'ANTISM', 'PESQUISA DE ANTICORPOS ANTI-SM', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(35, 9, 202030350, 'ANTIRO', 'PESQUISA DE ANTICORPOS ANTI-SS-A (RO)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(36, 9, 202030369, 'ANTILA', 'PESQUISA DE ANTICORPOS ANTI-SS-B (LA)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(37, 9, 202030474, 'ASLO', 'PESQUISA DE ANTICORPOS ANTIESTREPTOLISINA O (ASLO)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(38, 9, 202030555, 'ANTI TPO', 'PESQUISA DE ANTICORPOS ANTIMICROSSOMAS / ANTI-TPO / ANTI PEROXIDASE TIREOIDEANA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(39, 9, 202030598, 'FAN', 'PESQUISA DE ANTICORPOS ANTINUCLEO', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(40, 9, 202030628, 'ANTI TIREOG', 'PESQUISA DE ANTICORPOS ANTITIREOGLOBULINA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(41, 5, 202030636, 'ANTI HBS', 'PESQUISA DE ANTICORPOS CONTRA ANTIGENO DE SUPERFICIE DO VIRUS DA HEPATITE B / ANTI-HBS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(42, 5, 202030644, 'ANTI HBE', 'PESQUISA DE ANTICORPOS CONTRA ANTIGENO E DO VIRUS DA HEPATITE B / ANTI-HBE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(43, 5, 202030679, 'ANTI HCV', 'PESQUISA DE ANTICORPOS CONTRA O VIRUS DA HEPATITE C / ANTI-HCV', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(44, 5, 202030725, 'CLAEIE', 'PESQUISA DE ANTICORPOS EIE ANTICLAMIDIA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(45, 5, 202030733, 'ANTI EPSTEIN', 'PESQUISA DE ANTICORPOS HETEROFILOS CONTA O VIRUS EPSTEIN-BARR', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(46, 5, 202030741, 'IGGCITOMEGA', 'PESQUISA DE ANTICORPOS IGG ANTICITOMEGALOVIRUS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(47, 5, 202030768, 'IGGTOXO', 'PESQUISA DE ANTICORPOS IGG ANTITOXOPLASMA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(48, 5, 202030784, 'ANTI HBC TOTAL', 'PESQUISA DE ANTICORPOS IGG E IGM CONTRA ANTIGENO CENTRAL DO VIRUS DA HEPATITE B / ANTI-HBC-TOTAL', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(49, 5, 202030806, 'IGGHAV', 'PESQUISA DE ANTICORPOS IGG CONTRA O VIRUS DA HEPATITE A / HAV-IGG', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(50, 5, 202030814, 'IGGRUB', 'PESQUISA DE ANTICORPOS IGG CONTRA O VIRUS DA RUBEOLA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(51, 5, 202030830, 'IGGEPSTEIN', 'PESQUISA DE ANTICORPOS IGG CONTRA O VIRUS EPSTEIN-BARR', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(52, 5, 202030849, 'IGGHERPSIMPLES', 'PESQUISA DE ANTICORPOS IGG CONTRA O VIRUS HERPES SIMPLES', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(53, 5, 202030857, 'IGMCITOMEGA', 'PESQUISA DE ANTICORPOS IGM ANTICITOMEGALOVIRUS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(54, 5, 202030873, 'IGMTOXO', 'PESQUISA DE ANTICORPOS IGM ANTITOXOPLASMA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(55, 5, 202030890, 'ANTI HBC IGM', 'PESQUISA DE ANTICORPOS IGM CONTRA ANTIGENO CENTRAL DO VIRUS DA HEPATITE B (ANTI-HBC-IGM)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(56, 5, 202030911, 'IGMHAV', 'PESQUISA DE ANTICORPOS IGM CONTRA O VIRUS DA HEPATITE A / HAV-IGM', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(57, 5, 202030920, 'IGMRUB', 'PESQUISA DE ANTICORPOS IGM CONTRA O VIRUS DA RUBEOLA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(58, 5, 202030946, 'IGMEPSTEIN', 'PESQUISA DE ANTICORPOS IGM CONTRA O VIRUS EPSTEIN-BARR', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(59, 5, 202030954, 'IGMHERPSIMPLES', 'PESQUISA DE ANTICORPOS IGM CONTRA O VIRUS HERPES SIMPLES', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(60, 9, 202030962, 'CEA', 'PESQUISA DE ANTIGENO CARCINOEMBRIONARIO / CEA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(61, 5, 202030970, 'HBSAG', 'PESQUISA DE ANTIGENO DE SUPERFICIE DO VIRUS DA HEPATITE B / HBSAG', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(62, 5, 202030989, 'HBEAG', 'PESQUISA DE ANTIGENO E DO VIRUS DA HEPATITE B / HBEAG', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(63, 2, 202031012, 'FRWROSE', 'PESQUISA DE FATOR REUMATOIDE (WAALER-ROSE)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(64, 9, 202031039, 'IGEALERG', 'PESQUISA DE IMUNOGLOBULINA E (IGE) ALERGENO-ESPECIFICA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(65, 9, 2020310391, 'IGEPTERON', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (D1) ÁCAROS - D. PTERONYSSINUS', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(66, 9, 2020310392, 'IGETARTRAZ', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (C717) ALIMENTOS -TARTRAZINA CORANTE AMARELO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(67, 9, 2020310393, 'IGEBLOMIA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (D201) ÁCAROS - BLOMIA TROPICALIS', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(68, 9, 2020310394, 'IGEACARUS', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (D70) ÁCAROS - ACARUS SIRO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(69, 9, 2020310395, 'IGEDOMES', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (D73) ÁCAROS - G. DOMESTICUS', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(70, 9, 2020310396, 'IGEPELOCAO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (E5) - PELO DE CÃO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(71, 9, 2020310397, 'IGECLARAOVO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F1) ALIMENTOS - CLARA DE OVO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(72, 9, 2020310398, 'IGECHOCOLATE', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F105) ALIMENTOS - CHOCOLATE', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(73, 9, 2020310399, 'IGEAMENDOIM', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F13) ALIMENTOS - AMENDOIM', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(74, 9, 20203103910, 'IGEABACAXI', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F210) ALIMENTOS- ABACAXI', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(75, 9, 20203103911, 'IGEALBUMINA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F232) ALIMENTOS - OVO ALBUMINA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(76, 9, 20203103912, 'IGECARNEPORCO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F26) ALIMENTOS - CARNE DE PORCO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(77, 9, 20203103913, 'IGEMARACUJA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F294) ALIMENTOS- MARACUJA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(78, 9, 20203103914, 'IGELEITECABRA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F300) - ALIMENTOS - LEITE DE CABRA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(79, 9, 20203103915, 'IGECENOURA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F31) ALIMENTOS - CENOURA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(80, 9, 20203103916, 'IGEBETERRABA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F319) ALIMENTOS - BETERRABA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(81, 9, 20203103917, 'IGEMELANCIA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F329) ALIMENTOS - MELANCIA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(82, 9, 20203103918, 'IGECORANTECARMIM', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F340) COCHONILHA - CORANTE VERMELHO CARMIM', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(83, 9, 20203103919, 'IGEAZEITONA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F342) ALIMENTOS - AZEITONA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(84, 9, 20203103920, 'IGECOCO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F36) ALIMENTOS - COCO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(85, 9, 20203103921, 'IGETRIGO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F4) ALIMENTOS - TRIGO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(86, 9, 20203103922, 'IGEGEMAOVO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F75) ALIMENTOS - GEMA DE OVO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(87, 9, 20203103923, 'IGECARNEFRANGO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F83) ALIMENTOS - CARNE DE FRANGO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(88, 9, 20203103924, 'IGEMANGA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F91) ALIMENTOS - MANGA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(89, 9, 20203103925, 'IGEBANANA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F92) - ALIMENTOS – BANANA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(90, 9, 20203103926, 'IGECACAU', 'IGE ESPECÍFICO (F93) ALIMENTOS – CACAU', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(91, 9, 20203103927, 'IGEVENENOABELHA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (I1) VENENO DE ABELHA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(92, 9, 20203103928, 'IGEMUTUCA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (I204) TABANUS - MOSCA MUTUCA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(93, 9, 20203103929, 'IGEBARATA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (I206) ANIMAIS - BARATA VERMELHA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(94, 9, 20203103930, 'IGEMARIMBONDO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (I4) - INSETOS – MARIMBONDO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(95, 9, 20203103931, 'IGEBARATA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (I6) INSETOS - BARATA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(96, 9, 20203103932, 'IGEFORMIGALAVAP', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (I70) INSETOS - FORMIGA LAVA P', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(97, 9, 20203103933, 'IGEMOSQUITO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (I71) INSETOS – MOSQUITO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(98, 9, 20203103934, 'IGEFARINAE', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (D2) ÁCAROS - D. FARINAE', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(99, 9, 20203103935, 'IGEMICROCERAS', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (D3) ÁCAROS - D. MICROCERAS', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(100, 9, 20203103936, NULL, 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F78) - CASEÍNA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(101, 9, 20203103937, 'IGEASPERGILLUS', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (M207) FUNGOS - ASPERGILLUS NIGER', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(102, 9, 20203103938, 'IGEFUMIGATUS', ' PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (M3) FUNGOS - A. FUMIGATUS', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(103, 9, 20203103939, 'IGETABACO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (O201) - FOLHA DE TABACO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(104, 9, 20203103940, 'IGEALHO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F47) ALIMENTOS - ALHO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(105, 9, 20203103941, 'IGEASPERGILLUS', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (M228) FUNGOS - ASPERGILLUS FLAVUS', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(106, 9, 20203103942, 'IGEPELOGATO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (E17) - PELO DE GATO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(107, 9, 20203103943, 'IGEMILHO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F8) ALIMENTOS - MILHO', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(108, 9, 20203103944, 'IGESOJA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F14) ALIMENTOS - GRÃO DE SOJA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(109, 9, 20203103945, 'IGETOMATE', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F25) ALIMENTOS - TOMATE', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(110, 9, 20203103946, 'IGEBATATA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (F35) ALIMENTOS - BATATA', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(111, 9, 20203103947, 'IGECASPACAO', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO - CASPA DE CAO (RAST5)', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(112, 9, 20203103948, 'IGEFUNGOS', 'PESQUISA DE IMUNOGLOBULINA E - IGE MÚLTIPLO (MX1) - FUNGOS', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(113, 9, 20203103949, 'IGEPODECASA', 'PESQUISA DE IMUNOGLOBULINA E - IGE ESPECÍFICO (H2) PÓ DE CASA - HOLLISTER STIER', NULL, 1, 0, NULL, 1, NULL, 0, 'A'),
(114, 5, 202031110, 'VDRL', 'TESTE NÃO TREPONEMICO P/ DETECÇÃO DE SIFILIS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(115, 5, 202031128, 'IGGFTA', 'TESTE FTA-ABS IGG P/ DIAGNOSTICO DA SIFILIS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(116, 5, 202031136, 'IGMFTA', 'TESTE FTA-ABS IGM P/ DIAGNOSTICO DA SIFILIS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(117, 5, 202031179, 'VDRLGEST', 'TESTE NÃO TREPONEMICO P/ DETECÇÃO DE SIFILIS EM GESTANTES', 0, 0, 0, NULL, 1, NULL, 0, 'F'),
(118, 9, 202031187, 'RECOMBHUMANO-IGA', 'DOSAGEM DE ANTICORPOS ANTITRANSGLUTAMINASE RECOMBINANTE HUMANO IGA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(119, 2, 202031209, 'TROPONINA', 'DOSAGEM DE TROPONINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(120, 9, 202031217, 'CA125', 'DOSAGEM DO ANTÍGENO CA 125', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(121, 7, 202040127, 'EPF', 'PESQUISA DE OVOS E CISTOS DE PARASITAS / PARASITOLÓGICO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(122, 8, 202040135, 'PRF', 'PESQUISA DE ROTAVIRUS NAS FEZES', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(123, 7, 202040143, 'PSOF', 'PESQUISA DE SANGUE OCULTO NAS FEZES / SANGUE OCULTO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(124, 6, 202050017, 'EAS', 'ANALISE DE CARACTERES FISICOS, ELEMENTOS E SEDIMENTO DA URINA / EAS / URINA TIPO 1', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(125, 6, 202050025, 'CLEACRE24H', 'CLEARANCE DE CREATININA (URINA DE 24H)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(126, 6, 2020500251, 'CLEACREAI', 'CLEARANCE DE CREATININA URINA (AMOSTRA ISOLADA)', NULL, 0, 0, NULL, 1, NULL, 0, 'A'),
(127, 6, 202050092, 'MICALBUMIN24H', 'DOSAGEM DE MICROALBUMINA NA URINA DE 24H / MICROALBUMINÚRIA 24H', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(128, 6, 2020500921, 'MICALBUMIN', 'DOSAGEM DE MICROALBUMINA NA URINA AMOSTRA ISOLADA / MICROALBUMINÚRIA AMOSTRA ISOLADA', NULL, 0, 0, NULL, 1, NULL, 0, 'A'),
(129, 6, 202050114, 'PROT24H', 'DOSAGEM DE PROTEINAS (URINA DE 24 HORAS) / PROTEINÚRIA 24 HORAS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(130, 2, 202060039, 'T3REVERSO', 'DETERMINACAO DE T3 REVERSO', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(131, 4, 202060047, '17ALFHID', 'DOSAGEM DE 17-ALFA-HIDROXIPROGESTERONA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(132, 4, 202060098, 'ALDO', 'DOSAGEM DE ALDOSTERONA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(133, 4, 202060110, 'ANDROST', 'DOSAGEM DE ANDROSTENEDIONA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(134, 4, 202060136, 'CORT', 'DOSAGEM DE CORTISOL', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(135, 4, 202060144, 'DHEA', 'DOSAGEM DE DEHIDROEPIANDROSTERONA (DHEA)', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(136, 4, 202060160, 'EST', 'DOSAGEM DE ESTRADIOL', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(137, 4, 202060179, 'ESTRI', 'DOSAGEM DE ESTRIOL', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(138, 4, 202060187, 'ESTRO', 'DOSAGEM DE ESTRONA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(139, 4, 202060268, 'INS', 'DOSAGEM DE INSULINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(140, 4, 202060276, 'PTH', 'DOSAGEM DE PARATORMONIO', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(141, 4, 202060284, 'PEPC', 'DOSAGEM DE PEPTIDEO C', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(142, 4, 202060292, 'PROGES', 'DOSAGEM DE PROGESTERONA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(143, 4, 202060306, 'PROLAC', 'DOSAGEM DE PROLACTINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(144, 4, 202060322, 'IGF1', 'DOSAGEM DE SOMATOMEDINA C / IGF1', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(145, 4, 202060330, 'DHEAS', 'DOSAGEM DE SULFATO DE HIDROEPIANDROSTERONA / DHEAS', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(146, 4, 202060349, 'TESTTOTAL', 'DOSAGEM DE TESTOSTERONA / TESTOSTERONA TOTAL', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(147, 4, 202060357, 'TESTLIV', 'DOSAGEM DE TESTOSTERONA LIVRE', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(148, 4, 202060365, 'TIREOG', 'DOSAGEM DE TIREOGLOBULINA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(149, 4, 202060373, 'T4', 'DOSAGEM DE TIROXINA / T4', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(150, 4, 202060381, 'T4L', 'DOSAGEM DE TIROXINA LIVRE / T4 LIVRE', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(151, 4, 202060390, 'T3', 'DOSAGEM DE TRIIODOTIRONINA / T3', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(152, 4, 202060462, 'TESTDIABETES', 'TESTE P/ INVESTIGACAO DO DIABETES INSIPIDUS', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(153, 4, 202060470, 'MACROPOLAC', 'PESQUISA DE MACROPROLACTINA', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(154, 2, 202070050, 'ACVALP', 'DOSAGEM DE ACIDO VALPROICO / VALPROATO', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(155, 2, 202070085, 'ALUM', 'DOSAGEM DE ALUMINIO ', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(156, 2, 202070123, 'BARB', 'DOSAGEM DE BARBITURATOS / FENOBARBITAL', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(157, 2, 202070140, 'CADM', 'DOSAGEM DE CADMIO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(158, 2, 202070158, 'CARBAM', 'DOSAGEM DE CARBAMAZEPINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(159, 2, 202070174, 'CHUMB', 'DOSAGEM DE CHUMBO / PB', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(160, 2, 202070190, 'COBR', 'DOSAGEM DE COBRE /CU', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(161, 2, 202070204, 'DIGI', 'DOSAGEM DE DIGITALICOS (DIGOXINA, DIGITOXINA)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(162, 2, 202070220, 'FENIT', 'DOSAGEM DE FENITOINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(163, 2, 202070255, 'LIT', 'DOSAGEM DE LITIO / LITIMIA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(164, 2, 202070263, 'MERC', 'DOSAGEM DE MERCURIO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(165, 2, 202070352, 'ZINC', 'DOSAGEM DE ZINCO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(166, 6, 202080013, 'ANTIB', 'ANTIBIOGRAMA / TSA / TESTE DE SENSIBILIDADE A ANTIBIÓTICOS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(167, 6, 202080072, 'GRAM', 'BACTERIOSCOPIA / GRAM', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(168, 6, 2020800801, 'UROCULT', 'CULTURA DE BACTERIAS P/ IDENTIFICACAO / UROCULTURA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(169, 6, 202080137, 'CULTFUN', 'CULTURA PARA IDENTIFICACAO DE FUNGOS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(170, 6, 202080145, 'MICRODIRETO', 'EXAME MICROBIOLOGICO A FRESCO (DIRETO)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(171, 6, 202080153, 'HEMOCULT', 'HEMOCULTURA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(172, 6, 202080161, 'AUTOMICRO', 'IDENTIFICACAO AUTOMATIZADA DE MICROORGANISMOS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(173, 3, 202090051, 'LCR', 'CONTAGEM ESPECIFICA DE CELULAS NO LIQUOR', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(174, 9, 202090264, 'ESPERMO', 'PESQUISA DE ESPERMATOZOIDES (APOS VASECTOMIA) / ESPERMOGRAMA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(175, 2, 202090302, 'LATEXFR', 'PROVA DO LATEX P/ PESQUISA DO FATOR REUMATOIDE / LATEX', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(176, 3, 202120023, 'ABO', 'DETERMINACAO DIRETA E REVERSA DE GRUPO ABO / GRUPO SANGUÍNEO / TIPO SANGUÍNEO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(177, 3, 202120082, 'FATRH', 'PESQUISA DE FATOR RH (INCLUI D FRACO)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(178, 3, 202120090, 'COOMBSIND', 'TESTE INDIRETO DE ANTIGLOBULINA HUMANA (TIA) / COOMBS INDIRETO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(179, 3, 202120104, 'TITANTAB', 'TITULACAO DE ANTICORPOS ANTI A E/OU ANTI B', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(180, 6, 202080080, 'BACCULT', 'CULTURA DE BACTERIAS P/ IDENTIFICACAO', 0, 0, 1, NULL, 1, NULL, 1, 'F'),
(181, 8, 202030750, 'IGGLEISHMAN', 'ANTILEISHMANIAS - PESQUISA DE ANTICORPOS IGG', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(182, 8, 202030776, 'IGGCHAGAS', 'CHAGAS - PESQUISA DE ANTICORPOS IGG ANTITRYPANOSOMA CRUZI', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(183, 8, 202030881, 'IGMCHAGAS', 'CHAGAS - PESQUISA DE ANTICORPOS IGM ANTITRYPANOSOMA CRUZI', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(184, 8, 202020460, 'CHAGASPD', 'CHAGAS - PESQUISA DIRETA DE TRIPANOSSOMA CRUZI POR GOTA ESPESSA E ESFREGAÇO', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(185, 8, 2020307921, 'IGGCHIKUNGUNYA', 'CHIKUNGUNYA - PESQUISA DE ANTICORPOS IGG', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(186, 8, 2020309031, 'IGMCHIKUNGUNYA', 'CHIKUNGUNYA - PESQUISA DE ANTICORPOS IGM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(187, 8, 202407305, 'RTPCRCHIKUNGUNYA', 'CHIKUNGUNYA RT-PCR ARBOVIRUS', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(188, 8, 213010380, 'ISOLVIRUSDENGUE', 'DENGUE - ISOLAMENTO DO VÍRUS', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(189, 8, 40324192, 'NS1DENGUE', 'DENGUE - PESQUISA ANTÍGENO NS1', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(190, 8, 202030792, 'IGGDENGUE', 'DENGUE - PESQUISA DE ANTICORPOS IGG', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(191, 8, 202030903, 'IGMDENGUE', 'DENGUE - PESQUISA DE ANTICORPOS IGM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(192, 8, 202407301, 'RTPCRDENGUE', 'DENGUE RT-PCR ARBOVIRUS', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(193, 8, 2020801371, 'ESPOROTCULT', 'ESPOROTRICOSE - SWAB DE FERIDA - CULTURA PARA IDENTIFICAÇÃO DE FUNGOS', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(194, 8, 202407303, 'ISOLVIRUSFA', 'FEBRE AMARELA - ISOLAMENTO VIRAL', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(195, 8, 213010623, 'IGMFA', 'FEBRE AMARELA - PESQUISA DE ANTICORPOS IGM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(196, 8, 202407304, 'RTPCRFA', 'FEBRE AMARELA RT-PCR', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(197, 8, 213010259, 'FMAC1', 'FEBRE MACULOSA - IMUNOFLUORESCENCIA INDIRETA P/ IDENTIFICAÇÃO DA RICKETTSIA RICKTTSII', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(198, 8, 2130102591, 'FMAC2', 'FEBRE MACULOSA - IMUNOFLUORESCENCIA INDIRETA P/ IDENTIFICAÇÃO DA RICKETTSIA RICKTTSII ', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(199, 8, 202407302, 'RTPCRFM', 'FEBRE MACULOSA RT-PCR', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(200, 8, 202080056, 'HANS', 'HANSENIASE - BACILOSCOPIA DIRETA P/ BAAR', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(201, 8, 213010798, 'CVHBV', 'HEPATITE B CARGA VIRAL  - DETECÇÃO RÁPIDA DA CARGA VIRAL DO HBV', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(202, 8, 213010801, 'CVHCV', 'HEPATITE C CARGA VIRAL - DETECÇÃO RÁPIDA DA CARGA VIRAL DO HCV', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(203, 8, 213010500, 'CVHIVRNA', 'HIV - QUANTIFICACAO DA CARGA VIRAL (RNA). \r\n*OBS: PARA RN EXPOSTO HIV:SEGUIMENTO LABORATORIAL CONFORME PORTARIA SECTICS/MS Nº 76, DE 28 DE DEZEMBRO DE 2023', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(204, 8, 213010011, 'CVHIV', 'HIV DETERMINACAO DE CARGA VIRAL POR RT-PCR ', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(205, 8, 202407306, 'DNAPROHIV', 'HIV DNA PRÓ-VIRAL', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(206, 8, 202031241, 'GENOTIPHIV', 'HIV GENOTIPAGEM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(207, 8, 213010054, 'EXADLEISHTA', 'LEISHMANIOSE TEGUMENTAR - EXAME PARASITOLOGICO DIRETO  P/ LEISHMANIAS', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(208, 8, 213010020, 'LEPTIGM', 'LEPTOSPIROSE - PESQUISA DE ANTICORPOS IGM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(209, 8, 213010810, 'LINFCD4', 'LINFÓCITOS CD4 (CONTAGEM RÁPIDA)', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(210, 8, 202030024, 'LINFTOTAL', 'LINFOCITOS CD4/CD8 (CONTAGEM DE)', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(211, 8, 202407307, 'IGMLYME', 'LYME  - IGM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(212, 8, 202407308, 'IGGLYME', 'LYME - IGG', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(213, 8, 202407309, 'RTPCRLYME', 'LYME - RT-PCR', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(214, 8, 202020452, 'MALARGOTAE', 'MALÁRIA -  PESQUISA DE PLASMODIO - GOTA ESPESSA', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(215, 8, 213010216, 'MALARIMUNOCROM', 'MALÁRIA - IMUNOCROMATOGRAFIA P/ IDENTIFICACAO DE PLASMODIOS', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(216, 8, 2024073010, 'TOXBOTFEZES', 'PESQUISA DE TOXINA BOTULÍNICA (FEZES IN NATURA)', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(217, 8, 2024073011, 'TOXBOTSORO', 'PESQUISA DE TOXINA BOTULÍNICA (SORO-SANGUE)', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(218, 8, 2020302451, 'PPD', 'PPD - INTRADERMORREACAO COM DERIVADO PROTEICO PURIFICADO', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(219, 8, 213010704, 'SORONRAIVA', 'RAIVA - TESTE DE SORONEUTRALIZACAO P/ IDENTIFICACAO DO VIRUS DA RAIVA (SFIMT)', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(220, 8, 202030814, 'IGGRUB', 'RUBEOLA - PESQUISA DE ANTICORPOS IGG', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(221, 8, 202030920, 'IGMRUB', 'RUBEOLA - PESQUISA DE ANTICORPOS IGM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(222, 8, 202030695, 'IGMSARAM', 'SARAMPO - PESQUISA DE ANTICORPOS IGM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(223, 8, 214010198, 'LFLAM', 'TESTE RÁPIDO LF-LAM PARA TUBERCULOSE', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(224, 8, 2020307681, 'TOXOAG', 'TOXOPLASMOSE - TESTE DE AVIDEZ', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(225, 2, 202010279, 'HDL', 'DOSAGEM DE COLESTEROL HDL', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(226, 2, 202010287, 'LDL', 'DOSAGEM DE COLESTEROL LDL', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(227, 8, 2024073012, 'CULTESCARRO', 'TUBERCULOSE -  PARA BAAR - CULTURA DE ESCARRO  (P/BAAR)', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(228, 2, 202010295, 'CTF', 'DOSAGEM DE COLESTEROL TOTAL', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(229, 8, 202080064, 'BAARTBCONT', 'TUBERCULOSE - BACILOSCOPIA DIRETA P/ BAAR (CONTROLE)', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(230, 2, 202010309, 'COLI', 'DOSAGEM DE COLINESTERASE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(231, 2, 202010317, 'CRE', 'DOSAGEM DE CREATININA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(232, 2, 202010325, 'CPK', 'DOSAGEM DE CREATINOFOSFOQUINASE CPK / CK TOTAL', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(233, 8, 202080048, 'BAARTBDIAG', 'TUBERCULOSE - BACILOSCOPIA DIRETA P/ BAAR (DIAGNÓSTICA)', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(234, 2, 202010333, 'CKMB', 'DOSAGEM DE CREATINOFOSFOQUINASE FRACAO MB / ISOENZIMA CREATINOFOSFOQUINASE MB', 0, 1, 0, NULL, 1, NULL, 0, 'A'),
(235, 8, 202031365, 'IGRA', 'TUBERCULOSE IGRA - TESTE DE LIBERAÇÃO DE INTERFERON-GAMA PARA ILTB', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(236, 2, 202010368, 'LDH', 'DOSAGEM DE DESIDROGENASE LATICA / DHL / LACTATO DESIDROGENASE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(237, 8, 202090361, 'TRMTB', 'TUBERCULOSE TESTE RÁPIDO MOLECULAR (TRMTB) - TESTE MOLECULAR PARA A DETECÇÃO DO COMPLEXO MYCOBACTERIUM\r\nTUBERCULOSIS', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(238, 2, 202010384, 'FERRI', 'DOSAGEM DE FERRITINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(239, 8, 40314561, 'RTPCRZIKA', 'ZIKA RT-PCR ARBOVIRUS', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(240, 2, 202010392, 'FER', 'DOSAGEM DE FERRO SERICO / FE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(241, 2, 202010406, 'AFOL', 'DOSAGEM DE FOLATO / DOSAGEM DE ÁCIDO FÓLICO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(242, 2, 202010422, 'FA', 'DOSAGEM DE FOSFATASE ALCALINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(243, 2, 202010430, 'FOSF', 'DOSAGEM DE FOSFORO / FOSFATEMIA / FOSFATO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(244, 8, 2020307922, 'IGGZIKA', 'ZIKA VIRUS - PESQUISA DE ANTICORPOS IGG', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(245, 8, 2020309032, 'IGMZIKA', 'ZIKA VIRUS - PESQUISA DE ANTICORPOS IGM', 0, 0, 1, NULL, 1, NULL, 1, 'A'),
(246, 2, 202010465, 'GAMA GT', 'DOSAGEM DE GAMA-GLUTAMIL-TRANSFERASE / GAMA GT', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(247, 2, 202010473, 'GLI', 'DOSAGEM DE GLICOSE / GLICEMIA / GLICEMIA JEJUM', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(248, 2, 202010481, 'GLIFOSDES', 'DOSAGEM DE GLICOSE-6-FOSFATO DESIDROGENASE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(249, 2, 202010503, 'GLICOSILAD', 'DOSAGEM DE HEMOGLOBINA GLICOSILADA / HBAC1 / HEMOGLOBINA GLICADA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(250, 2, 202010538, 'LACTATO', 'DOSAGEM DE LACTATO / ÁCIDO LÁTICO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(251, 2, 202010554, 'LIPASE', 'DOSAGEM DE LIPASE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(252, 2, 202010562, 'MAGNESIO', 'DOSAGEM DE MAGNESIO / MG2+ / MAGNESEMIA / MG', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(253, 2, 202010570, 'MUCO', 'DOSAGEM DE MUCO-PROTEINAS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(254, 2, 202010600, 'K', 'DOSAGEM DE POTASSIO / CALEMIA / K+', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(255, 2, 202010619, 'PRO TOTAL', 'DOSAGEM DE PROTEINAS TOTAIS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(256, 2, 202010627, 'PTFALBUM', 'DOSAGEM DE PROTEINAS TOTAIS E FRACOES - ALBUMINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(257, 2, 202010635, 'NA', 'DOSAGEM DE SODIO / NATREMIA / NA+', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(258, 2, 202010643, 'TGO', 'DOSAGEM DE TRANSAMINASE GLUTAMICO-OXALACETICA TGO / AST', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(259, 2, 202010651, 'TGP', 'DOSAGEM DE TRANSAMINASE GLUTAMICO-PIRUVICA TGP / ALT', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(260, 2, 202010660, 'TRANSF', 'DOSAGEM DE TRANSFERRINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(261, 2, 202010678, 'TRIGL', 'DOSAGEM DE TRIGLICERIDEOS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(262, 2, 202010694, 'UR', 'DOSAGEM DE UREIA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(263, 2, 202010708, 'B12', 'DOSAGEM DE VITAMINA B12 / CIANOCOBALAMINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(264, 9, 202010724, 'ELEPRO', 'ELETROFORESE DE PROTEINAS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(265, 2, 202010732, 'GASO', 'GASOMETRIA (PH PCO2 PO2 BICARBONATO AS2 (EXCESSO OU DEFICIT BASE ) / PH E GASES SANGUÍNEOS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(266, 2, 202010767, '25HXVITD', 'DOSAGEM DE 25 HIDROXIVITAMINA D / VITAMINA D', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(267, 3, 202020029, 'PLAQ', 'CONTAGEM DE PLAQUETAS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(268, 3, 202020037, 'RETI', 'CONTAGEM DE RETICULOCITOS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(269, 3, 202020070, 'TC', 'DETERMINACAO DE TEMPO DE COAGULACAO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(270, 3, 202020096, 'TS', 'DETERMINACAO DE TEMPO DE SANGRAMENTO -DUKE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(271, 3, 202020134, 'TTPA', 'DETERMINACAO DE TEMPO DE TROMBOPLASTINA PARCIAL ATIVADA (TTPA) / PTTK', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(272, 3, 202020142, 'TAP', 'DETERMINACAO DE TEMPO E ATIVIDADE DA PROTROMBINA / TAP', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(273, 3, 202020150, 'VHS', 'DETERMINACAO DE VELOCIDADE DE HEMOSSEDIMENTACAO / VHS', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(274, 3, 202020290, 'FIBRIN', 'DOSAGEM DE FIBRINOGENIO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(275, 3, 202020304, 'HB', 'DOSAGEM DE HEMOGLOBINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(276, 9, 202020355, 'ELEHB', 'ELETROFORESE DE HEMOGLOBINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(277, 3, 202020363, 'ERI', 'ERITROGRAMA (ERITROCITOS, HEMOGLOBINA, HEMATOCRITO)', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(278, 3, 202020371, 'HEMAT', 'HEMATOCRITO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(279, 3, 202020380, 'HMG', 'HEMOGRAMA COMPLETO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(280, 9, 202020410, 'CEL LE', 'PESQUISA DE CELULAS LE', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(281, 3, 202020487, 'CONPROT', 'PROVA DE CONSUMO DE PROTROMBINA', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(282, 3, 202020495, 'RECOAG', 'PROVA DE RETRACAO DO COAGULO', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(283, 9, 202030067, 'CH50', 'DETERMINACAO DE COMPLEMENTO /CH50', 0, 0, 0, NULL, 1, NULL, 0, 'A'),
(284, 2, 202030075, 'FR', 'DETERMINACAO DE FATOR REUMATOIDE', 0, 0, 0, NULL, 1, NULL, 0, 'A');

-- --------------------------------------------------------

--
-- Estrutura para tabela `exames_financeiro`
--

CREATE TABLE `exames_financeiro` (
  `id` bigint UNSIGNED NOT NULL,
  `user` bigint UNSIGNED NOT NULL,
  `CodExameLaboratorial` bigint UNSIGNED NOT NULL,
  `contrato` bigint UNSIGNED NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `observacao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `exames_financeiro`
--

INSERT INTO `exames_financeiro` (`id`, `user`, `CodExameLaboratorial`, `contrato`, `valor`, `observacao`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 2, 1.95, NULL, '2025-03-24 01:43:29', '2025-03-27 17:28:52'),
(2, 1, 2, 2, 2.25, NULL, '2025-03-24 01:43:29', '2025-03-24 19:46:04'),
(3, 1, 3, 2, 3.21, NULL, '2025-03-24 01:43:29', '2025-03-24 21:23:58'),
(4, 1, 4, 2, 12.34, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(5, 1, 5, 2, 2.21, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(6, 1, 6, 2, 1.98, NULL, '2025-03-24 01:43:29', '2025-03-24 19:36:46'),
(7, 1, 7, 2, 1.53, NULL, '2025-03-24 01:43:29', '2025-03-24 20:00:36'),
(8, 1, 8, 2, 3.12, NULL, '2025-03-24 01:43:29', '2025-03-24 19:51:39'),
(9, 1, 9, 2, 14.99, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(10, 1, 10, 2, 59.76, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(11, 1, 11, 2, 30.67, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(12, 1, 12, 2, 37.31, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(13, 1, 13, 2, 7.22, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(14, 1, 14, 2, 99.99, NULL, '2025-03-24 01:43:29', '2025-03-24 20:02:46'),
(15, 1, 15, 2, 3.18, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(16, 1, 16, 2, 22.24, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(17, 1, 17, 2, 7.80, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(18, 1, 18, 2, 77.53, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(19, 1, 19, 2, 61.32, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(20, 1, 20, 2, 28.89, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(21, 1, 21, 2, 64.90, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(22, 1, 22, 2, 322.51, NULL, '2025-03-24 01:43:29', '2025-03-24 20:02:08'),
(23, 1, 23, 2, 18.23, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(24, 1, 24, 2, 9.56, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(25, 1, 25, 2, 43.77, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(26, 1, 26, 2, 8.32, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(27, 1, 27, 2, 68.22, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(28, 1, 28, 2, 99.26, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(29, 1, 29, 2, 26.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(30, 1, 30, 2, 69.90, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(31, 1, 31, 2, 85.98, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(32, 1, 32, 2, 91.38, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(33, 1, 33, 2, 75.24, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(34, 1, 34, 2, 19.41, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(35, 1, 35, 2, 87.81, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(36, 1, 36, 2, 22.52, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(37, 1, 37, 2, 36.00, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(38, 1, 38, 2, 30.40, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(39, 1, 39, 2, 91.71, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(40, 1, 40, 2, 58.00, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(41, 1, 41, 2, 85.56, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(42, 1, 42, 2, 86.53, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(43, 1, 43, 2, 7.93, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(44, 1, 44, 2, 36.71, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(45, 1, 45, 2, 90.35, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(46, 1, 46, 2, 11.50, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(47, 1, 47, 2, 70.74, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(48, 1, 48, 2, 53.20, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(49, 1, 49, 2, 77.06, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(50, 1, 50, 2, 2.49, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(51, 1, 51, 2, 23.64, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(52, 1, 52, 2, 25.18, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(53, 1, 53, 2, 1.64, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(54, 1, 54, 2, 64.43, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(55, 1, 55, 2, 80.70, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(56, 1, 56, 2, 36.92, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(57, 1, 57, 2, 50.10, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(58, 1, 58, 2, 65.44, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(59, 1, 59, 2, 30.57, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(60, 1, 60, 2, 6.26, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(61, 1, 61, 2, 66.33, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(62, 1, 62, 2, 13.31, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(63, 1, 63, 2, 67.82, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(64, 1, 64, 2, 20.37, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(65, 1, 65, 2, 64.14, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(66, 1, 66, 2, 18.38, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(67, 1, 67, 2, 49.06, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(68, 1, 68, 2, 29.75, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(69, 1, 69, 2, 56.00, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(70, 1, 70, 2, 91.69, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(71, 1, 71, 2, 72.83, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(72, 1, 72, 2, 87.26, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(73, 1, 73, 2, 24.49, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(74, 1, 74, 2, 93.18, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(75, 1, 75, 2, 44.58, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(76, 1, 76, 2, 68.26, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(77, 1, 77, 2, 12.28, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(78, 1, 78, 2, 73.97, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(79, 1, 79, 2, 43.36, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(80, 1, 80, 2, 40.81, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(81, 1, 81, 2, 66.73, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(82, 1, 82, 2, 92.03, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(83, 1, 83, 2, 19.90, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(84, 1, 84, 2, 99.54, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(85, 1, 85, 2, 18.32, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(86, 1, 86, 2, 58.69, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(87, 1, 87, 2, 18.44, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(88, 1, 88, 2, 22.87, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(89, 1, 89, 2, 83.16, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(90, 1, 90, 2, 13.34, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(91, 1, 91, 2, 81.41, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(92, 1, 92, 2, 96.61, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(93, 1, 93, 2, 91.74, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(94, 1, 94, 2, 23.17, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(95, 1, 95, 2, 74.51, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(96, 1, 96, 2, 51.90, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(97, 1, 97, 2, 92.19, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(98, 1, 98, 2, 82.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(99, 1, 99, 2, 73.23, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(100, 1, 100, 2, 25.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(101, 1, 101, 2, 79.95, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(102, 1, 102, 2, 56.38, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(103, 1, 103, 2, 50.68, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(104, 1, 104, 2, 75.71, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(105, 1, 105, 2, 52.26, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(106, 1, 106, 2, 10.41, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(107, 1, 107, 2, 19.72, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(108, 1, 108, 2, 18.47, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(109, 1, 109, 2, 63.49, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(110, 1, 110, 2, 21.49, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(111, 1, 111, 2, 1.34, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(112, 1, 112, 2, 22.02, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(113, 1, 113, 2, 47.99, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(114, 1, 114, 2, 73.92, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(115, 1, 115, 2, 59.42, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(116, 1, 116, 2, 49.59, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(117, 1, 117, 2, 7.15, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(118, 1, 118, 2, 40.56, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(119, 1, 119, 2, 100.62, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(120, 1, 120, 2, 23.72, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(121, 1, 121, 2, 45.34, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(122, 1, 122, 2, 85.85, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(123, 1, 123, 2, 79.61, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(124, 1, 124, 2, 68.57, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(125, 1, 125, 2, 57.11, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(126, 1, 126, 2, 35.23, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(127, 1, 127, 2, 47.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(128, 1, 128, 2, 56.38, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(129, 1, 129, 2, 47.02, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(130, 1, 130, 2, 29.92, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(131, 1, 131, 2, 31.50, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(132, 1, 132, 2, 66.93, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(133, 1, 133, 2, 79.11, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(134, 1, 134, 2, 15.86, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(135, 1, 135, 2, 93.14, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(136, 1, 136, 2, 8.42, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(137, 1, 137, 2, 77.97, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(138, 1, 138, 2, 52.15, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(139, 1, 139, 2, 3.66, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(140, 1, 140, 2, 11.29, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(141, 1, 141, 2, 68.17, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(142, 1, 142, 2, 30.09, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(143, 1, 143, 2, 66.03, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(144, 1, 144, 2, 26.64, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(145, 1, 145, 2, 58.73, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(146, 1, 146, 2, 23.09, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(147, 1, 147, 2, 19.50, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(148, 1, 148, 2, 26.94, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(149, 1, 149, 2, 5.64, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(150, 1, 150, 2, 62.18, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(151, 1, 151, 2, 10.77, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(152, 1, 152, 2, 26.52, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(153, 1, 153, 2, 91.31, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(154, 1, 154, 2, 99.31, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(155, 1, 155, 2, 3.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(156, 1, 156, 2, 45.72, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(157, 1, 157, 2, 33.19, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(158, 1, 158, 2, 17.92, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(159, 1, 159, 2, 82.79, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(160, 1, 160, 2, 49.93, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(161, 1, 161, 2, 11.27, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(162, 1, 162, 2, 24.55, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(163, 1, 163, 2, 78.15, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(164, 1, 164, 2, 61.85, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(165, 1, 165, 2, 79.43, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(166, 1, 166, 2, 30.07, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(167, 1, 167, 2, 58.96, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(168, 1, 168, 2, 95.52, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(169, 1, 169, 2, 81.99, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(170, 1, 170, 2, 58.60, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(171, 1, 171, 2, 23.90, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(172, 1, 172, 2, 71.69, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(173, 1, 173, 2, 65.85, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(174, 1, 174, 2, 90.18, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(175, 1, 175, 2, 44.71, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(176, 1, 176, 2, 32.63, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(177, 1, 177, 2, 11.43, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(178, 1, 178, 2, 87.15, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(179, 1, 179, 2, 80.46, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(180, 1, 180, 2, 42.72, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(181, 1, 181, 2, 16.77, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(182, 1, 182, 2, 98.93, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(183, 1, 183, 2, 12.30, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(184, 1, 184, 2, 4.10, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(185, 1, 185, 2, 97.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(186, 1, 186, 2, 89.61, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(187, 1, 187, 2, 40.90, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(188, 1, 188, 2, 8.39, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(189, 1, 189, 2, 38.41, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(190, 1, 190, 2, 1.24, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(191, 1, 191, 2, 89.23, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(192, 1, 192, 2, 21.36, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(193, 1, 193, 2, 94.34, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(194, 1, 194, 2, 10.88, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(195, 1, 195, 2, 37.49, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(196, 1, 196, 2, 38.21, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(197, 1, 197, 2, 3.44, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(198, 1, 198, 2, 2.51, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(199, 1, 199, 2, 94.48, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(200, 1, 200, 2, 83.44, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(201, 1, 201, 2, 70.86, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(202, 1, 202, 2, 39.52, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(203, 1, 203, 2, 66.83, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(204, 1, 204, 2, 62.39, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(205, 1, 205, 2, 21.98, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(206, 1, 206, 2, 14.02, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(207, 1, 207, 2, 82.06, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(208, 1, 208, 2, 92.86, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(209, 1, 209, 2, 17.59, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(210, 1, 210, 2, 91.92, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(211, 1, 211, 2, 46.10, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(212, 1, 212, 2, 31.74, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(213, 1, 213, 2, 27.73, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(214, 1, 214, 2, 29.19, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(215, 1, 215, 2, 80.82, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(216, 1, 216, 2, 90.91, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(217, 1, 217, 2, 1.67, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(218, 1, 218, 2, 99.33, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(219, 1, 219, 2, 26.75, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(220, 1, 220, 2, 90.01, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(221, 1, 221, 2, 88.76, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(222, 1, 222, 2, 18.49, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(223, 1, 223, 2, 90.38, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(224, 1, 224, 2, 56.27, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(225, 1, 225, 2, 33.03, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(226, 1, 226, 2, 79.02, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(227, 1, 227, 2, 86.39, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(228, 1, 228, 2, 88.43, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(229, 1, 229, 2, 65.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(230, 1, 230, 2, 57.08, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(231, 1, 231, 2, 76.09, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(232, 1, 232, 2, 33.18, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(233, 1, 233, 2, 44.55, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(234, 1, 234, 2, 22.50, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(235, 1, 235, 2, 38.04, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(236, 1, 236, 2, 97.47, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(237, 1, 237, 2, 28.25, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(238, 1, 238, 2, 50.62, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(239, 1, 239, 2, 15.75, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(240, 1, 240, 2, 4.12, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(241, 1, 241, 2, 81.59, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(242, 1, 242, 2, 65.46, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(243, 1, 243, 2, 27.47, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(244, 1, 244, 2, 49.57, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(245, 1, 245, 2, 12.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(246, 1, 246, 2, 13.69, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(247, 1, 247, 2, 11.58, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(248, 1, 248, 2, 82.94, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(249, 1, 249, 2, 71.19, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(250, 1, 250, 2, 74.21, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(251, 1, 251, 2, 22.74, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(252, 1, 252, 2, 84.68, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(253, 1, 253, 2, 64.46, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(254, 1, 254, 2, 83.55, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(255, 1, 255, 2, 51.87, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(256, 1, 256, 2, 25.76, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(257, 1, 257, 2, 29.72, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(258, 1, 258, 2, 8.79, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(259, 1, 259, 2, 36.05, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(260, 1, 260, 2, 14.12, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(261, 1, 261, 2, 73.72, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(262, 1, 262, 2, 64.66, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(263, 1, 263, 2, 67.37, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(264, 1, 264, 2, 78.83, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(265, 1, 265, 2, 20.22, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(266, 1, 266, 2, 87.14, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(267, 1, 267, 2, 36.85, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(268, 1, 268, 2, 96.03, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(269, 1, 269, 2, 93.53, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(270, 1, 270, 2, 94.38, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(271, 1, 271, 2, 75.75, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(272, 1, 272, 2, 3.59, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(273, 1, 273, 2, 0.05, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(274, 1, 274, 2, 26.33, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(275, 1, 275, 2, 84.32, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(276, 1, 276, 2, 13.48, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(277, 1, 277, 2, 51.88, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(278, 1, 278, 2, 75.63, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(279, 1, 279, 2, 53.84, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(280, 1, 280, 2, 47.56, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(281, 1, 281, 2, 19.98, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(282, 1, 282, 2, 35.68, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(283, 1, 283, 2, 67.48, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(284, 1, 284, 2, 71.32, NULL, '2025-03-24 01:43:29', '2025-03-24 01:43:29'),
(569, 1, 1, 1, 0.02, NULL, NULL, '2025-03-26 17:49:26'),
(570, 1, 2, 1, 0.12, NULL, NULL, NULL),
(571, 1, 3, 1, 1.23, NULL, NULL, NULL),
(572, 1, 4, 1, 12.34, NULL, NULL, NULL),
(573, 1, 5, 1, 123.45, NULL, NULL, NULL),
(574, 1, 6, 1, 1234.56, NULL, NULL, NULL),
(575, 1, 7, 1, 12345.67, NULL, NULL, NULL),
(576, 1, 8, 1, 123456.78, NULL, NULL, NULL),
(577, 1, 9, 1, 123456.78, NULL, NULL, NULL),
(578, 1, 10, 1, 9.86, NULL, NULL, '2025-03-24 22:51:07'),
(579, 1, 11, 1, 88.41, NULL, NULL, NULL),
(580, 1, 12, 1, 11.50, NULL, NULL, NULL),
(581, 1, 13, 1, 73.20, NULL, NULL, NULL),
(582, 1, 14, 1, 72.16, NULL, NULL, NULL),
(583, 1, 15, 1, 95.44, NULL, NULL, NULL),
(584, 1, 16, 1, 47.52, NULL, NULL, NULL),
(585, 1, 17, 1, 84.82, NULL, NULL, NULL),
(586, 1, 18, 1, 55.45, NULL, NULL, NULL),
(587, 1, 19, 1, 13.37, NULL, NULL, NULL),
(588, 1, 20, 1, 39.71, NULL, NULL, NULL),
(589, 1, 21, 1, 51.46, NULL, NULL, NULL),
(590, 1, 22, 1, 47.72, NULL, NULL, NULL),
(591, 1, 23, 1, 16.24, NULL, NULL, NULL),
(592, 1, 24, 1, 87.45, NULL, NULL, NULL),
(593, 1, 25, 1, 42.30, NULL, NULL, NULL),
(594, 1, 26, 1, 26.72, NULL, NULL, NULL),
(595, 1, 27, 1, 54.22, NULL, NULL, NULL),
(596, 1, 28, 1, 71.27, NULL, NULL, NULL),
(597, 1, 29, 1, 90.75, NULL, NULL, NULL),
(598, 1, 30, 1, 28.37, NULL, NULL, NULL),
(599, 1, 31, 1, 38.61, NULL, NULL, NULL),
(600, 1, 32, 1, 36.49, NULL, NULL, NULL),
(601, 1, 33, 1, 42.81, NULL, NULL, NULL),
(602, 1, 34, 1, 100.80, NULL, NULL, NULL),
(603, 1, 35, 1, 39.42, NULL, NULL, NULL),
(604, 1, 36, 1, 6.26, NULL, NULL, NULL),
(605, 1, 37, 1, 40.19, NULL, NULL, NULL),
(606, 1, 38, 1, 2.35, NULL, NULL, NULL),
(607, 1, 39, 1, 59.84, NULL, NULL, NULL),
(608, 1, 40, 1, 95.83, NULL, NULL, NULL),
(609, 1, 41, 1, 76.33, NULL, NULL, NULL),
(610, 1, 42, 1, 43.71, NULL, NULL, NULL),
(611, 1, 43, 1, 96.07, NULL, NULL, NULL),
(612, 1, 44, 1, 94.16, NULL, NULL, NULL),
(613, 1, 45, 1, 0.98, NULL, NULL, NULL),
(614, 1, 46, 1, 82.02, NULL, NULL, NULL),
(615, 1, 47, 1, 0.92, NULL, NULL, NULL),
(616, 1, 48, 1, 96.64, NULL, NULL, NULL),
(617, 1, 49, 1, 60.48, NULL, NULL, NULL),
(618, 1, 50, 1, 63.29, NULL, NULL, NULL),
(619, 1, 51, 1, 81.00, NULL, NULL, NULL),
(620, 1, 52, 1, 9.93, NULL, NULL, NULL),
(621, 1, 53, 1, 94.78, NULL, NULL, NULL),
(622, 1, 54, 1, 85.10, NULL, NULL, NULL),
(623, 1, 55, 1, 8.35, NULL, NULL, NULL),
(624, 1, 56, 1, 80.12, NULL, NULL, NULL),
(625, 1, 57, 1, 63.16, NULL, NULL, NULL),
(626, 1, 58, 1, 17.11, NULL, NULL, NULL),
(627, 1, 59, 1, 61.17, NULL, NULL, NULL),
(628, 1, 60, 1, 66.35, NULL, NULL, NULL),
(629, 1, 61, 1, 29.18, NULL, NULL, NULL),
(630, 1, 62, 1, 36.09, NULL, NULL, NULL),
(631, 1, 63, 1, 99.94, NULL, NULL, NULL),
(632, 1, 64, 1, 4.52, NULL, NULL, NULL),
(633, 1, 65, 1, 5.75, NULL, NULL, NULL),
(634, 1, 66, 1, 25.73, NULL, NULL, NULL),
(635, 1, 67, 1, 49.11, NULL, NULL, NULL),
(636, 1, 68, 1, 5.35, NULL, NULL, NULL),
(637, 1, 69, 1, 72.26, NULL, NULL, NULL),
(638, 1, 70, 1, 29.63, NULL, NULL, NULL),
(639, 1, 71, 1, 7.85, NULL, NULL, NULL),
(640, 1, 72, 1, 50.75, NULL, NULL, NULL),
(641, 1, 73, 1, 6.55, NULL, NULL, NULL),
(642, 1, 74, 1, 100.58, NULL, NULL, NULL),
(643, 1, 75, 1, 60.12, NULL, NULL, NULL),
(644, 1, 76, 1, 16.59, NULL, NULL, NULL),
(645, 1, 77, 1, 17.55, NULL, NULL, NULL),
(646, 1, 78, 1, 99.04, NULL, NULL, NULL),
(647, 1, 79, 1, 59.40, NULL, NULL, NULL),
(648, 1, 80, 1, 15.80, NULL, NULL, NULL),
(649, 1, 81, 1, 51.83, NULL, NULL, NULL),
(650, 1, 82, 1, 18.71, NULL, NULL, NULL),
(651, 1, 83, 1, 84.81, NULL, NULL, NULL),
(652, 1, 84, 1, 7.88, NULL, NULL, NULL),
(653, 1, 85, 1, 80.90, NULL, NULL, NULL),
(654, 1, 86, 1, 98.66, NULL, NULL, NULL),
(655, 1, 87, 1, 35.50, NULL, NULL, NULL),
(656, 1, 88, 1, 34.26, NULL, NULL, NULL),
(657, 1, 89, 1, 31.21, NULL, NULL, NULL),
(658, 1, 90, 1, 68.09, NULL, NULL, NULL),
(659, 1, 91, 1, 42.13, NULL, NULL, NULL),
(660, 1, 92, 1, 85.47, NULL, NULL, NULL),
(661, 1, 93, 1, 11.59, NULL, NULL, NULL),
(662, 1, 94, 1, 73.78, NULL, NULL, NULL),
(663, 1, 95, 1, 4.48, NULL, NULL, NULL),
(664, 1, 96, 1, 88.56, NULL, NULL, NULL),
(665, 1, 97, 1, 28.31, NULL, NULL, NULL),
(666, 1, 98, 1, 96.21, NULL, NULL, NULL),
(667, 1, 99, 1, 31.51, NULL, NULL, NULL),
(668, 1, 100, 1, 27.61, NULL, NULL, NULL),
(669, 1, 101, 1, 52.97, NULL, NULL, NULL),
(670, 1, 102, 1, 55.65, NULL, NULL, NULL),
(671, 1, 103, 1, 38.99, NULL, NULL, NULL),
(672, 1, 104, 1, 15.47, NULL, NULL, NULL),
(673, 1, 105, 1, 30.46, NULL, NULL, NULL),
(674, 1, 106, 1, 41.33, NULL, NULL, NULL),
(675, 1, 107, 1, 17.46, NULL, NULL, NULL),
(676, 1, 108, 1, 29.95, NULL, NULL, NULL),
(677, 1, 109, 1, 51.65, NULL, NULL, NULL),
(678, 1, 110, 1, 66.83, NULL, NULL, NULL),
(679, 1, 111, 1, 8.70, NULL, NULL, NULL),
(680, 1, 112, 1, 15.45, NULL, NULL, NULL),
(681, 1, 113, 1, 75.37, NULL, NULL, NULL),
(682, 1, 114, 1, 85.95, NULL, NULL, NULL),
(683, 1, 115, 1, 68.84, NULL, NULL, NULL),
(684, 1, 116, 1, 57.26, NULL, NULL, NULL),
(685, 1, 117, 1, 59.88, NULL, NULL, NULL),
(686, 1, 118, 1, 68.72, NULL, NULL, NULL),
(687, 1, 119, 1, 86.85, NULL, NULL, NULL),
(688, 1, 120, 1, 80.57, NULL, NULL, NULL),
(689, 1, 121, 1, 75.66, NULL, NULL, NULL),
(690, 1, 122, 1, 73.61, NULL, NULL, NULL),
(691, 1, 123, 1, 52.66, NULL, NULL, NULL),
(692, 1, 124, 1, 48.21, NULL, NULL, NULL),
(693, 1, 125, 1, 32.44, NULL, NULL, NULL),
(694, 1, 126, 1, 59.48, NULL, NULL, NULL),
(695, 1, 127, 1, 17.56, NULL, NULL, NULL),
(696, 1, 128, 1, 42.66, NULL, NULL, NULL),
(697, 1, 129, 1, 22.93, NULL, NULL, NULL),
(698, 1, 130, 1, 63.60, NULL, NULL, NULL),
(699, 1, 131, 1, 37.26, NULL, NULL, NULL),
(700, 1, 132, 1, 60.91, NULL, NULL, NULL),
(701, 1, 133, 1, 97.19, NULL, NULL, NULL),
(702, 1, 134, 1, 94.06, NULL, NULL, NULL),
(703, 1, 135, 1, 80.60, NULL, NULL, NULL),
(704, 1, 136, 1, 93.37, NULL, NULL, NULL),
(705, 1, 137, 1, 95.19, NULL, NULL, NULL),
(706, 1, 138, 1, 78.34, NULL, NULL, NULL),
(707, 1, 139, 1, 78.77, NULL, NULL, NULL),
(708, 1, 140, 1, 19.65, NULL, NULL, NULL),
(709, 1, 141, 1, 80.42, NULL, NULL, NULL),
(710, 1, 142, 1, 34.06, NULL, NULL, NULL),
(711, 1, 143, 1, 87.57, NULL, NULL, NULL),
(712, 1, 144, 1, 83.13, NULL, NULL, NULL),
(713, 1, 145, 1, 45.78, NULL, NULL, NULL),
(714, 1, 146, 1, 47.65, NULL, NULL, NULL),
(715, 1, 147, 1, 74.18, NULL, NULL, NULL),
(716, 1, 148, 1, 16.04, NULL, NULL, NULL),
(717, 1, 149, 1, 47.01, NULL, NULL, NULL),
(718, 1, 150, 1, 66.71, NULL, NULL, NULL),
(719, 1, 151, 1, 48.56, NULL, NULL, NULL),
(720, 1, 152, 1, 69.23, NULL, NULL, NULL),
(721, 1, 153, 1, 55.59, NULL, NULL, NULL),
(722, 1, 154, 1, 79.58, NULL, NULL, NULL),
(723, 1, 155, 1, 37.10, NULL, NULL, NULL),
(724, 1, 156, 1, 1.86, NULL, NULL, NULL),
(725, 1, 157, 1, 14.61, NULL, NULL, NULL),
(726, 1, 158, 1, 100.32, NULL, NULL, NULL),
(727, 1, 159, 1, 38.02, NULL, NULL, NULL),
(728, 1, 160, 1, 94.52, NULL, NULL, NULL),
(729, 1, 161, 1, 72.93, NULL, NULL, NULL),
(730, 1, 162, 1, 98.70, NULL, NULL, NULL),
(731, 1, 163, 1, 51.38, NULL, NULL, NULL),
(732, 1, 164, 1, 53.26, NULL, NULL, NULL),
(733, 1, 165, 1, 32.91, NULL, NULL, NULL),
(734, 1, 166, 1, 7.49, NULL, NULL, NULL),
(735, 1, 167, 1, 12.42, NULL, NULL, NULL),
(736, 1, 168, 1, 73.07, NULL, NULL, NULL),
(737, 1, 169, 1, 95.19, NULL, NULL, NULL),
(738, 1, 170, 1, 38.01, NULL, NULL, NULL),
(739, 1, 171, 1, 45.56, NULL, NULL, NULL),
(740, 1, 172, 1, 36.08, NULL, NULL, NULL),
(741, 1, 173, 1, 2.84, NULL, NULL, NULL),
(742, 1, 174, 1, 84.81, NULL, NULL, NULL),
(743, 1, 175, 1, 38.09, NULL, NULL, NULL),
(744, 1, 176, 1, 11.00, NULL, NULL, NULL),
(745, 1, 177, 1, 86.84, NULL, NULL, NULL),
(746, 1, 178, 1, 46.67, NULL, NULL, NULL),
(747, 1, 179, 1, 99.06, NULL, NULL, NULL),
(748, 1, 180, 1, 8.17, NULL, NULL, NULL),
(749, 1, 181, 1, 55.65, NULL, NULL, NULL),
(750, 1, 182, 1, 26.58, NULL, NULL, NULL),
(751, 1, 183, 1, 61.35, NULL, NULL, NULL),
(752, 1, 184, 1, 37.43, NULL, NULL, NULL),
(753, 1, 185, 1, 19.03, NULL, NULL, NULL),
(754, 1, 186, 1, 69.82, NULL, NULL, NULL),
(755, 1, 187, 1, 71.74, NULL, NULL, NULL),
(756, 1, 188, 1, 28.89, NULL, NULL, NULL),
(757, 1, 189, 1, 99.85, NULL, NULL, NULL),
(758, 1, 190, 1, 24.88, NULL, NULL, NULL),
(759, 1, 191, 1, 95.32, NULL, NULL, NULL),
(760, 1, 192, 1, 70.00, NULL, NULL, NULL),
(761, 1, 193, 1, 97.74, NULL, NULL, NULL),
(762, 1, 194, 1, 11.27, NULL, NULL, NULL),
(763, 1, 195, 1, 71.19, NULL, NULL, NULL),
(764, 1, 196, 1, 80.41, NULL, NULL, NULL),
(765, 1, 197, 1, 64.48, NULL, NULL, NULL),
(766, 1, 198, 1, 44.10, NULL, NULL, NULL),
(767, 1, 199, 1, 98.20, NULL, NULL, NULL),
(768, 1, 200, 1, 18.46, NULL, NULL, NULL),
(769, 1, 201, 1, 47.52, NULL, NULL, NULL),
(770, 1, 202, 1, 8.16, NULL, NULL, NULL),
(771, 1, 203, 1, 95.49, NULL, NULL, NULL),
(772, 1, 204, 1, 28.22, NULL, NULL, NULL),
(773, 1, 205, 1, 33.67, NULL, NULL, NULL),
(774, 1, 206, 1, 53.48, NULL, NULL, NULL),
(775, 1, 207, 1, 70.23, NULL, NULL, NULL),
(776, 1, 208, 1, 37.40, NULL, NULL, NULL),
(777, 1, 209, 1, 15.81, NULL, NULL, NULL),
(778, 1, 210, 1, 70.87, NULL, NULL, NULL),
(779, 1, 211, 1, 79.61, NULL, NULL, NULL),
(780, 1, 212, 1, 25.05, NULL, NULL, NULL),
(781, 1, 213, 1, 100.80, NULL, NULL, NULL),
(782, 1, 214, 1, 30.98, NULL, NULL, NULL),
(783, 1, 215, 1, 48.81, NULL, NULL, NULL),
(784, 1, 216, 1, 44.26, NULL, NULL, NULL),
(785, 1, 217, 1, 93.65, NULL, NULL, NULL),
(786, 1, 218, 1, 29.98, NULL, NULL, NULL),
(787, 1, 219, 1, 28.94, NULL, NULL, NULL),
(788, 1, 220, 1, 19.20, NULL, NULL, NULL),
(789, 1, 221, 1, 86.50, NULL, NULL, NULL),
(790, 1, 222, 1, 29.71, NULL, NULL, NULL),
(791, 1, 223, 1, 28.22, NULL, NULL, NULL),
(792, 1, 224, 1, 41.58, NULL, NULL, NULL),
(793, 1, 225, 1, 8.08, NULL, NULL, NULL),
(794, 1, 226, 1, 31.87, NULL, NULL, NULL),
(795, 1, 227, 1, 63.35, NULL, NULL, NULL),
(796, 1, 228, 1, 66.45, NULL, NULL, NULL),
(797, 1, 229, 1, 62.20, NULL, NULL, NULL),
(798, 1, 230, 1, 47.45, NULL, NULL, NULL),
(799, 1, 231, 1, 0.14, NULL, NULL, NULL),
(800, 1, 232, 1, 35.32, NULL, NULL, NULL),
(801, 1, 233, 1, 91.27, NULL, NULL, NULL),
(802, 1, 234, 1, 45.60, NULL, NULL, NULL),
(803, 1, 235, 1, 72.58, NULL, NULL, NULL),
(804, 1, 236, 1, 11.24, NULL, NULL, NULL),
(805, 1, 237, 1, 23.88, NULL, NULL, NULL),
(806, 1, 238, 1, 33.13, NULL, NULL, NULL),
(807, 1, 239, 1, 42.52, NULL, NULL, NULL),
(808, 1, 240, 1, 79.91, NULL, NULL, NULL),
(809, 1, 241, 1, 19.81, NULL, NULL, NULL),
(810, 1, 242, 1, 83.11, NULL, NULL, NULL),
(811, 1, 243, 1, 76.67, NULL, NULL, NULL),
(812, 1, 244, 1, 59.14, NULL, NULL, NULL),
(813, 1, 245, 1, 0.03, NULL, NULL, NULL),
(814, 1, 246, 1, 90.56, NULL, NULL, NULL),
(815, 1, 247, 1, 4.85, NULL, NULL, NULL),
(816, 1, 248, 1, 18.77, NULL, NULL, NULL),
(817, 1, 249, 1, 42.74, NULL, NULL, NULL),
(818, 1, 250, 1, 48.39, NULL, NULL, NULL),
(819, 1, 251, 1, 21.74, NULL, NULL, NULL),
(820, 1, 252, 1, 25.25, NULL, NULL, NULL),
(821, 1, 253, 1, 68.68, NULL, NULL, NULL),
(822, 1, 254, 1, 88.19, NULL, NULL, NULL),
(823, 1, 255, 1, 53.46, NULL, NULL, NULL),
(824, 1, 256, 1, 97.75, NULL, NULL, NULL),
(825, 1, 257, 1, 99.85, NULL, NULL, NULL),
(826, 1, 258, 1, 61.44, NULL, NULL, NULL),
(827, 1, 259, 1, 25.58, NULL, NULL, NULL),
(828, 1, 260, 1, 27.51, NULL, NULL, NULL),
(829, 1, 261, 1, 76.54, NULL, NULL, NULL),
(830, 1, 262, 1, 55.05, NULL, NULL, NULL),
(831, 1, 263, 1, 55.42, NULL, NULL, NULL),
(832, 1, 264, 1, 74.30, NULL, NULL, NULL),
(833, 1, 265, 1, 53.46, NULL, NULL, NULL),
(834, 1, 266, 1, 27.79, NULL, NULL, NULL),
(835, 1, 267, 1, 44.24, NULL, NULL, NULL),
(836, 1, 268, 1, 1.74, NULL, NULL, NULL),
(837, 1, 269, 1, 17.15, NULL, NULL, NULL),
(838, 1, 270, 1, 9.52, NULL, NULL, NULL),
(839, 1, 271, 1, 42.26, NULL, NULL, NULL),
(840, 1, 272, 1, 80.27, NULL, NULL, NULL),
(841, 1, 273, 1, 54.70, NULL, NULL, NULL),
(842, 1, 274, 1, 89.59, NULL, NULL, NULL),
(843, 1, 275, 1, 8.86, NULL, NULL, NULL),
(844, 1, 276, 1, 28.03, NULL, NULL, NULL),
(845, 1, 277, 1, 90.53, NULL, NULL, NULL),
(846, 1, 278, 1, 67.77, NULL, NULL, NULL),
(847, 1, 279, 1, 70.25, NULL, NULL, NULL),
(848, 1, 280, 1, 72.37, NULL, NULL, NULL),
(849, 1, 281, 1, 60.15, NULL, NULL, NULL),
(850, 1, 282, 1, 32.45, NULL, NULL, NULL),
(851, 1, 283, 1, 15.84, NULL, NULL, NULL),
(852, 1, 284, 1, 97.31, NULL, NULL, NULL);

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
-- Estrutura para tabela `gastos`
--

CREATE TABLE `gastos` (
  `id` bigint UNSIGNED NOT NULL,
  `CodPaciente` int UNSIGNED NOT NULL,
  `CodRequisicao` int UNSIGNED NOT NULL,
  `valor_total` decimal(8,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `place` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mechanic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `replaces` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cost` double DEFAULT NULL,
  `obs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
(35, '2025_03_05_150027_create_maintenances_table', 4),
(36, '2025_03_05_153048_create_attaches_table', 4),
(37, '2025_03_19_133722_create_contratos_table', 5),
(38, '2025_03_23_174252_create_exames_financeiro_table', 6),
(39, '2025_03_25_080903_create_postos_coleta_table', 7),
(40, '2025_03_25_103625_create_cotas_financeiras_table', 7),
(41, '2025_03_30_083241_create_agendas_table', 8),
(42, '2025_03_30_083250_create_agendamentos_table', 9),
(43, '2025_03_30_195600_create_requisicoes_table', 9),
(44, '2025_03_30_195702_create_gastos_table', 9);

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
-- Estrutura para tabela `postos_coleta`
--

CREATE TABLE `postos_coleta` (
  `id` bigint UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `postos_coleta`
--

INSERT INTO `postos_coleta` (`id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(4, NULL, '2025-03-25 21:16:13', '2025-03-25 21:16:13'),
(7, NULL, '2025-03-25 21:16:16', '2025-03-25 21:16:16'),
(8, NULL, '2025-03-25 21:16:41', '2025-03-25 21:16:41'),
(9, NULL, '2025-03-25 21:17:22', '2025-03-25 21:17:22');

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
-- Estrutura para tabela `requisicoes`
--

CREATE TABLE `requisicoes` (
  `id` bigint UNSIGNED NOT NULL,
  `CodPaciente` int UNSIGNED NOT NULL,
  `data_agendamento` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
-- Índices de tabela `agendamentos`
--
ALTER TABLE `agendamentos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `agendamentos_agenda_foreign` (`agenda`);

--
-- Índices de tabela `agendas`
--
ALTER TABLE `agendas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `agendas_user_foreign` (`user`);

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
-- Índices de tabela `contratos`
--
ALTER TABLE `contratos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contratos_user_foreign` (`user`);

--
-- Índices de tabela `cotas_financeiras`
--
ALTER TABLE `cotas_financeiras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cotas_financeiras_posto_coleta_foreign` (`posto_coleta`),
  ADD KEY `cotas_financeiras_contrato_foreign` (`contrato`),
  ADD KEY `cotas_financeiras_user_foreign` (`user`);

--
-- Índices de tabela `drivers`
--
ALTER TABLE `drivers`
  ADD UNIQUE KEY `drivers_id_unique` (`id`),
  ADD KEY `drivers_garagem_id_foreign` (`garagem_id`),
  ADD KEY `drivers_carro_favorito_foreign` (`carro_favorito`);

--
-- Índices de tabela `exames_clinicos`
--
ALTER TABLE `exames_clinicos`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `exames_financeiro`
--
ALTER TABLE `exames_financeiro`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exames_financeiro_user_foreign` (`user`),
  ADD KEY `exames_financeiro_contrato_foreign` (`contrato`);

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
-- Índices de tabela `gastos`
--
ALTER TABLE `gastos`
  ADD PRIMARY KEY (`id`);

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
-- Índices de tabela `postos_coleta`
--
ALTER TABLE `postos_coleta`
  ADD UNIQUE KEY `postos_coleta_id_unique` (`id`);

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
-- Índices de tabela `requisicoes`
--
ALTER TABLE `requisicoes`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT de tabela `agendamentos`
--
ALTER TABLE `agendamentos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `agendas`
--
ALTER TABLE `agendas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `attaches`
--
ALTER TABLE `attaches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `branches`
--
ALTER TABLE `branches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

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
-- AUTO_INCREMENT de tabela `contratos`
--
ALTER TABLE `contratos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `cotas_financeiras`
--
ALTER TABLE `cotas_financeiras`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `exames_clinicos`
--
ALTER TABLE `exames_clinicos`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=285;

--
-- AUTO_INCREMENT de tabela `exames_financeiro`
--
ALTER TABLE `exames_financeiro`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=853;

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
-- AUTO_INCREMENT de tabela `gastos`
--
ALTER TABLE `gastos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

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
-- AUTO_INCREMENT de tabela `requisicoes`
--
ALTER TABLE `requisicoes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

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
-- Restrições para tabelas `agendamentos`
--
ALTER TABLE `agendamentos`
  ADD CONSTRAINT `agendamentos_agenda_foreign` FOREIGN KEY (`agenda`) REFERENCES `agendas` (`id`);

--
-- Restrições para tabelas `agendas`
--
ALTER TABLE `agendas`
  ADD CONSTRAINT `agendas_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

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
-- Restrições para tabelas `contratos`
--
ALTER TABLE `contratos`
  ADD CONSTRAINT `contratos_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `cotas_financeiras`
--
ALTER TABLE `cotas_financeiras`
  ADD CONSTRAINT `cotas_financeiras_contrato_foreign` FOREIGN KEY (`contrato`) REFERENCES `contratos` (`id`),
  ADD CONSTRAINT `cotas_financeiras_posto_coleta_foreign` FOREIGN KEY (`posto_coleta`) REFERENCES `postos_coleta` (`id`),
  ADD CONSTRAINT `cotas_financeiras_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `drivers`
--
ALTER TABLE `drivers`
  ADD CONSTRAINT `drivers_carro_favorito_foreign` FOREIGN KEY (`carro_favorito`) REFERENCES `cars` (`id`),
  ADD CONSTRAINT `drivers_garagem_id_foreign` FOREIGN KEY (`garagem_id`) REFERENCES `garages` (`id`),
  ADD CONSTRAINT `drivers_id_foreign` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Restrições para tabelas `exames_financeiro`
--
ALTER TABLE `exames_financeiro`
  ADD CONSTRAINT `exames_financeiro_contrato_foreign` FOREIGN KEY (`contrato`) REFERENCES `contratos` (`id`),
  ADD CONSTRAINT `exames_financeiro_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

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
-- Restrições para tabelas `postos_coleta`
--
ALTER TABLE `postos_coleta`
  ADD CONSTRAINT `postos_coleta_id_foreign` FOREIGN KEY (`id`) REFERENCES `branches` (`id`);

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
